<?php
//////////////////////////////////////////////////////////////////////////////
//
// ------------------------------------------------------------------------ //
// This program is free software; you can redistribute it and/or modify     //
// it under the terms of the GNU General Public License as published by     //
// the Free Software Foundation; either version 2 of the License, or        //
// (at your option) any later version.                                      //
//                                                                          //
// This program is distributed in the hope that it will be useful, but      //
// WITHOUT ANY WARRANTY; without even the implied warranty of               //
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU         //
// General Public License for more details.                                 //
//                                                                          //
// You should have received a copy of the GNU General Public License        //
// along with this program; if not, write to the                            //
// Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,      //
// MA 02111-1307 USA                                                        //
// ------------------------------------------------------------------------ //
// code partially from Aiba and rmdp                                        //
// ------------------------------------------------------------------------ //
// import script dictionary  -> Lexikon                                     //
// ------------------------------------------------------------------------ //
//////////////////////////////////////////////////////////////////////////////

require_once __DIR__ . '/admin_header.php';
$op = '';

/****
 * Available operations
 ****/
switch ($op) {
    case 'default':
    default:
        xoops_cp_header();
        global $xoopsUser, $xoopsConfig, $xoopsDB, $xoopsModuleConfig, $xoopsModule;
        $myts = MyTextSanitizer::getInstance();
    //    lx_adminMenu(9, _AM_LEXIKON_IMPORT);
}
/****
 * Start Import
 ***
 * @param $msg
 */
function showerror($msg)
{
    global $xoopsDB;
    if ($xoopsDB->error() != '') {
        echo '<br>' . $msg . ' <br><span style="font-size: xx-small; "> -  ERROR: ' . $xoopsDB->error() . '</span>.';
    } else {
        echo '<br>' . $msg . ' O.K.!';
    }
}

/**
 * @param $text
 * @return mixed
 */
function import2db($text)
{
    return preg_replace(array("/'/i"), array("\'"), $text);
}

/**
 * @param $delete
 */
function DefinitionImport($delete)
{
    global $xoopsConfig, $xoopsDB, $xoopsModule, $myts;
    $sqlQuery = $xoopsDB->query('SELECT count(id) AS count FROM ' . $xoopsDB->prefix('dictionary'));
    list($count) = $xoopsDB->fetchRow($sqlQuery);
    if ($count < 1) {
        redirect_header('index.php', 1, 'Database for import missing or empty!');
    }

    $delete       = 0;
    $glocounter   = 0;
    $errorcounter = 0;

    if (isset($delete)) {
        $delete = (int)$_POST['delete'];
    } else {
        if (isset($delete)) {
            $delete = (int)$_POST['delete'];
        }
    }

    /****
     * delete all entries and categories
     ****/
    if ($delete) {
        // delete notifications
        xoops_notification_deletebymodule($xoopsModule->getVar('mid'));
        //get all entries
        $result3 = $xoopsDB->query('SELECT entryID FROM ' . $xoopsDB->prefix('lxentries') . '');
        //now for each entry, delete the coments
        while (list($entryID) = $xoopsDB->fetchRow($result3)) {
            xoops_comment_delete($xoopsModule->getVar('mid'), $entryID);
        }
        $resultC = $xoopsDB->query('SELECT categoryID FROM ' . $xoopsDB->prefix('lxcategories') . '');
        while (list($categoryID) = $xoopsDB->fetchRow($resultC)) {
            // delete permissions
            xoops_groupperm_deletebymoditem($xoopsModule->getVar('mid'), 'lexikon_view', $categoryID);
            xoops_groupperm_deletebymoditem($xoopsModule->getVar('mid'), 'lexikon_submit', $categoryID);
            xoops_groupperm_deletebymoditem($xoopsModule->getVar('mid'), 'lexikon_approve', $categoryID);
            xoops_groupperm_deletebymoditem($xoopsModule->getVar('mid'), 'lexikon_request', $categoryID);
        }
        // delete everything
        $sqlquery1 = $xoopsDB->queryF('TRUNCATE TABLE ' . $xoopsDB->prefix('lxentries'));
        $sqlquery2 = $xoopsDB->queryF('TRUNCATE TABLE ' . $xoopsDB->prefix('lxcategories'));
    }

    /****
     * Import ENTRIES
     ****/

    $sql1 = $xoopsDB->query('
                              SELECT *
                              FROM ' . $xoopsDB->prefix('dictionary') . ' ');

    $result1 = $xoopsDB->getRowsNum($sql1);
    if ($result1) {
        $fecha = time() - 1;
        while ($row2 = $xoopsDB->fetchArray($sql1)) {
            $entryID    = (int)$row2['id'];
            $init       = $myts->addSlashes($row2['letter']);
            $term       = $myts->addSlashes(import2db($row2['name']));
            $definition = $myts->addSlashes(import2db($row2['definition']));
            $datesub    = ++$fecha;
            $estado     = import2db($row2['state']);
            if ($estado === 'O') {
                $row2['state'] = 0;
            } else {
                $row2['state'] = 1;
            }
            if ($estado === 'D') {
                $row2['submit'] = 1 && $row2['state'] = 1;
            } else {
                $row2['submit'] = 0;
            }
            $comments = (int)$row2['comments'];
            ++$glocounter;

            if ($delete) {
                $ret1 = $xoopsDB->queryF('
                                         INSERT INTO ' . $xoopsDB->prefix('lxentries') . "
                                         (entryID, init, term, definition, url,  submit, datesub, offline, comments)
                                         VALUES
                                         ('$entryID', '$init', '$term', '$definition', '', '" . $row2['submit'] . "', '$datesub', '" . $row2['state'] . "', '$comments' )");
            } else {
                $ret1 = $xoopsDB->queryF('
                                         INSERT INTO ' . $xoopsDB->prefix('lxentries') . "
                                         (entryID, init, term, definition, url, submit, datesub, offline, comments)
                                         VALUES
                                         ('', '$init', '$term', '$definition', '', '" . $row2['submit'] . "', '$datesub', '" . $row2['state'] . "',  '$comments' )");
            }
            if (!$ret1) {
                ++$errorcounter;
                showerror('<br>Import term failed: <span style="color:red">entryID: ' . $entryID . '</span>: ' . $term . ' ...');
            }
            // update user posts count
            if ($ret1) {
                if ($uid) {
                    $memberHandler = xoops_getHandler('member');
                    $submitter     = $memberHandler->getUser($uid);
                    if (is_object($submitter)) {
                        $submitter->setVar('posts', $submitter->getVar('posts') + 1);
                        $res = $memberHandler->insertUser($submitter, true);
                        unset($submitter);
                    }
                }
            }
        }
    }
    /****
     * FINISH
     ****/

    $sqlQuery = $xoopsDB->query('
                              SELECT mid FROM ' . $xoopsDB->prefix('modules') . "
                              WHERE dirname = 'dictionary'");
    list($dicID) = $xoopsDB->fetchRow($sqlQuery);
    echo '<p>Dictionary Module ID: ' . $dicID . '</p>';
    echo '<p>Lexikon Module ID: ' . $xoopsModule->getVar('mid') . '<br>';
    //echo "<p>delete is on/off: ".$delete."</p>";

    $commentaire = $xoopsDB->queryF('
                                    UPDATE ' . $xoopsDB->prefix('xoopscomments') . "
                                    SET com_modid = '" . $xoopsModule->getVar('mid') . "'
                                    WHERE  com_modid = '" . $dicID . "'");
    if (!$commentaire) {
        showerror('Import comments failed:  ...');
    } else {
        showerror('Import comments :  ');
    }
    echo '<p>Update User Post count: O.K.!</p>';
    echo "<p><span style='color:red'>Incorrectly: " . $errorcounter . '</span></p>';
    echo '<p>Processed: ' . $glocounter . '</p>';
    echo '<H3>Import finished!</H3>';
    echo "<br><B><a href='index.php'>Back to Admin</a></B><p>";
    xoops_cp_footer();
}

/****
 * IMPORT FORM PLAIN HTML
 ****/

function FormImport()
{
    global $xoopsConfig, $xoopsDB, $xoopsModule;
    lx_importMenu(9);
    /** @var XoopsModuleHandler $moduleHandler */
    $moduleHandler    = xoops_getHandler('module');
    $dictionaryModule = $moduleHandler->getByDirname('dictionary');
    $got_options      = false;
    if (is_object($dictionaryModule)) {
        echo "<table width='100%' cellspacing='1' cellpadding='3' border='0' class='outer'>";
        echo '<tr>';
        echo "<td colspan='2' class='bg3' align='left'><span style='font-size: x-small; '><b>" . _AM_LEXIKON_MODULEHEADIMPORT . '</b></span></td>';
        echo '</tr>';

        echo '<tr>';
        echo "<td class='head' width = '200' align='center'><img src='"
             . XOOPS_URL
             . '/modules/'
             . $xoopsModule->dirname()
             . '/assets/images/dialog-important.png'
             . "' alt='' hspace='0' vspace='0' align='middle' style='margin-right: 10px;  margin-top: 20px;'></td>";
        echo "<td class='even' align='center'><br><B><span style='font-size: x-small; color: red; '>" . _AM_LEXIKON_IMPORTWARN . '</span></B><P></td>';
        echo '</tr>';

        echo '<tr>';
        echo "<td class='head' width = '200' align='left'><span style='font-size: x-small; '>" . _AM_LEXIKON_IMPORTDELWB . '</span></td>';
        echo "<td class='even' align='center'><FORM ACTION='importdictionary.php?op=import' METHOD=POST>
        <input type='radio' name='delete' value='1'>&nbsp;" . _YES . "&nbsp;&nbsp;
        <input type='radio' name='delete' value='0' checked>&nbsp;" . _NO . '<b>
        </td>';
        echo "</tr><tr><td width = '200' class='head' align='center'>&nbsp;</td>";
        echo "<td class='even' align='center'>
        <input type='submit' name='button' id='import' value='" . _AM_LEXIKON_IMPORT . "'>&nbsp;
        <input type='button' name='cancel' value='" . _CANCEL . "' onclick='history.go(-1);'></td>";
        echo "</tr></table><br>\n";
    } else {
        echo "<br><B><span style='color:red'>Module Dictionary not found on this site.</span></B><br><A HREF='index.php'>Back</A><P>";
    }
    xoops_cp_footer();
}

$op = isset($_GET['op']) ? $_GET['op'] : (isset($_POST['op']) ? $_POST['op'] : '');
switch ($op) {
    case 'import':
        $delete = isset($_GET['delete']) ? (int)$_GET['delete'] : (int)$_POST['delete'];
        DefinitionImport($delete);
        break;
    case 'main':
    default:
        FormImport();
        break;
}

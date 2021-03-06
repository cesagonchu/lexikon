<{* New Header block *}>
<table id="moduleheader">
    <tr>
        <td width="100%"><span class="leftheader"><a href="<{$xoops_url}>"><{$smarty.const._MD_LEXIKON_HOME}></a> <img
                        src='assets/images/arrow.gif' align='absmiddle'/> <a
                        href="<{$xoops_url}>/modules/<{$lang_moduledirname}>/index.php"><{$lang_modulename}></a></span>
        </td>
        <td width="100"><span class="rightheader"><{$lang_modulename}></span>
        </td>
    </tr>
</table>

<{if $empty == 1}>
    <div class="empty"><{$smarty.const._MD_LEXIKON_STILLNOTHINGHERE}></div>
<{/if}>

<div class="toprow">
    <div id="search">
        <fieldset>
            <legend><{$smarty.const._MD_LEXIKON_SEARCHENTRY}></legend>
            <{$searchform}>
        </fieldset>
    </div>
    <div class="inventory">
        <{$smarty.const._MD_LEXIKON_WEHAVE}><br>
        <{$smarty.const._MD_LEXIKON_DEFS}><{$publishedwords}><br>

        <{if $multicats == 1}><{$smarty.const._MD_LEXIKON_CATS}><{$totalcats}><br><{/if}>

        <input class="btnDefault" type="button" value="<{$smarty.const._MD_LEXIKON_SUBMITENTRY}>"
               onclick="location.href = 'submit.php'"/><br>
        <input class="btnDefault" type="button" value="<{$smarty.const._MD_LEXIKON_REQUESTDEF}>"
               onclick="location.href = 'request.php' "/>

    </div>
</div>
<{if $teaser == true}>
    <div class="teaser"><{$teaser}></div>
<{/if}>

<{* Alphabet block *}>
<div class="clearer">
    <div class="toprow">
        <fieldset>
            <legend><{$smarty.const._MD_LEXIKON_BROWSELETTER}></legend>
            <div class="letters">
                <a href="<{$xoops_url}>/modules/<{$lang_moduledirname}>/letter.php"
                   title="[ <{$publishedwords}> ]"><{$smarty.const._MD_LEXIKON_ALL}></a> |
                <{foreach item=letterlinks from=$alpha.initial}>
                    <{if $letterlinks.total > 0}> <a href="<{$xoops_url}>/modules/<{$lang_moduledirname}>/letter.php?init=<{$letterlinks.id}>" title="[ <{$letterlinks.total}> ]" ><{/if}><{$letterlinks.linktext}>
                    <{if $letterlinks.total > 0}></a><{/if}> |
                <{/foreach}>
                <{if $totalother > 0}><a
                        href="<{$xoops_url}>/modules/<{$lang_moduledirname}>/letter.php?init=<{$smarty.const._MD_LEXIKON_OTHER}>"
                        title="[ <{$totalother}> ]"><{/if}><{$smarty.const._MD_LEXIKON_OTHER}>
                    <{if $totalother > 0}></a><{/if}>
            </div>
        </fieldset>
    </div>
</div>

<{* Category block *}>
<{if $layout == '0'}>
    <{if $multicats == 1 && count($block0.categories) gt 0 }>
        <div class="clearer">
            <fieldset class="item"
                      style="border:1px solid #778;margin:1em 0;text-align:left;background-color:transparent;">
                <legend><{$smarty.const._MD_LEXIKON_BROWSECAT}></legend>
                <table id="Lxcategory" border="0">
                    <tr>
                        <td>
                            <a href="<{$xoops_url}>/modules/<{$lang_moduledirname}>/category.php"
                               title="[ <{$publishedwords}> ]"><{$smarty.const._MD_LEXIKON_ALLCATS}></a>
                            [<{$publishedwords}>]
                        </td>
                        <!-- Start category loop -->
                        <{foreach item=catlinks from=$block0.categories}>
                        <td>
                            <{if $catlinks.image != "" && $show_screenshot == true}>
                                <a href="<{$xoops_url}>/modules/<{$lang_moduledirname}>/category.php?categoryID=<{$catlinks.id}>"
                                   target="_parent"><img
                                            src="<{$xoops_url}>/uploads/<{$lang_moduledirname}>/categories/images/<{$catlinks.image}>"
                                            width="<{$logo_maximgwidth}>" align="left" class="floatLeft"
                                            alt="[<{$catlinks.name}>]&nbsp;[<{$catlinks.total}>]"/></A>
                            <{/if}>
                            <{if $catlinks.count > 0}>
                                <{if $catlinks.total > 0}><a href="<{$xoops_url}>/modules/<{$lang_moduledirname}>/category.php?categoryID=<{$catlinks.id}>" title="[<{$catlinks.total}>]"><{/if}><{$catlinks.linktext}>
                                <{if $catlinks.total > 0}></a> <{/if}>[<{$catlinks.total}>]
                            <{/if}>
                        </td>
                        <{if $catlinks.count is div by 4}>
                    </tr>
                    <tr>
                        <{/if}>
                        <{/foreach}>
                        <!-- End category loop -->
        </div>
        </tr>
        </table>
        </fieldset>
    <{/if}>
<{else}>
    <{if $multicats == 1}>
        <div class="clearer">
            <fieldset class="item"
                      style="border:1px solid #778;margin:1em 0;text-align:left;background-color: transparent;">
                <legend><{$smarty.const._MD_LEXIKON_BROWSECAT}></legend>
                <div class="letters" style="margin:1em 0;width:100%;padding:0;text-align:center;line-height:1.3em;">
                    <{foreach item=catlinks from=$block0.categories}>
                        <{if $catlinks.image != "" && $show_screenshot == true}>
                            <a href="<{$xoops_url}>/modules/<{$lang_moduledirname}>/category.php?categoryID=<{$category.id}>"
                               target="_parent">
                                <img src="<{$xoops_url}>/uploads/<{$lang_moduledirname}>/categories/images/<{$catlinks.image}>"
                                     width="<{$logo_maximgwidth}>" align="middle"
                                     alt="[<{$catlinks.total}>]"/></a>
                        <{/if}>
                        <{if $catlinks.total > 0}><a href="<{$xoops_url}>/modules/<{$lang_moduledirname}>/category.php?categoryID=<{$catlinks.id}>" title="[<{$catlinks.total}>]"><{/if}><{$catlinks.linktext}>
                        <{if $catlinks.total > 0}></a> <{/if}>[<{$catlinks.total}>] |
                    <{/foreach}>
                    <a href="<{$xoops_url}>/modules/<{$lang_moduledirname}>/category.php"
                       title="[ <{$publishedwords}> ]"><{$smarty.const._MD_LEXIKON_ALLCATS}></a>[<{$publishedwords}>]
                </div>
            </fieldset>
        </div>
    <{/if}>
<{/if}>
<br>
<div class="float30">
    <fieldset>
        <legend><{$smarty.const._MD_LEXIKON_RECENTENT}></legend>
        <ul>
            <{foreach item=newentries from=$block.newstuff}>
                <li>
                    <a href="<{$xoops_url}>/modules/<{$lang_moduledirname}>/entry.php?entryID=<{$newentries.id}>"><{$newentries.linktext}></a> <{if $showdate == 1}>
                        <span
                                style="font-size: xx-small; color: #456;">[<{$newentries.date}>]</span><{/if}>
                </li>
            <{/foreach}>
        </ul>
    </fieldset>
</div>

<div class="float30">
    <fieldset>
        <legend><{$smarty.const._MD_LEXIKON_POPULARENT}></legend>
        <ul>
            <{foreach item=popentries from=$block2.popstuff}>
                <li>
                    <a href="<{$xoops_url}>/modules/<{$lang_moduledirname}>/entry.php?entryID=<{$popentries.id}>"><{$popentries.linktext}></a> <{if $showcount == 1}>
                        <span
                                style="font-size: xx-small; color: #456;">[<{$popentries.counter}>
                        ]</span><{/if}></li>
            <{/foreach}>
        </ul>
    </fieldset>
</div>

<div>
    <fieldset>
        <legend><{$smarty.const._MD_LEXIKON_RANDOMTERM}></legend>
        <{if $multicats == 1}>
            <{if $empty != 1}>
                <div class="catname"><a
                            href="<{$xoops_url}>/modules/<{$lang_moduledirname}>/category.php?categoryID=<{$random.categoryID}>"><{$random.categoryname}></a>
                </div>
            <{/if}>
        <{/if}>
        <div class="pad4">
            <h5 class="term"><{$microlinks}><a
                        href="<{$xoops_url}>/modules/<{$lang_moduledirname}>/entry.php?entryID=<{$random.id}>"><{$random.term}></a>
            </h5>

            <div class="nopadding"><{$random.definition}></div>
        </div>
    </fieldset>
</div>

<{if $userisadmin == 1}>
    <div class="clearer2">
        <fieldset>
            <legend>
                <{$smarty.const._MD_LEXIKON_SUBANDREQ}>
            </legend>
            <div class="submission">
                <b><{$smarty.const._MD_LEXIKON_SUB}></b>
                <{if $wehavesubs == '0'}><{$smarty.const._MD_LEXIKON_NOSUB}><{/if}>
                <{foreach item=subentries from=$blockS.substuff}>
                    <a href="<{$xoops_url}>/modules/<{$lang_moduledirname}>/admin/entry.php?op=mod&entryID=<{$subentries.id}>"><{$subentries.linktext}></a>
                    &nbsp;
                <{/foreach}>
            </div>

            <div class="request">
                <b><{$smarty.const._MD_LEXIKON_REQ}></b>
                <{if $wehavereqs == '0'}><{$smarty.const._MD_LEXIKON_NOREQ}><{/if}>
                <{foreach item=reqentries from=$blockR.reqstuff}>
                    <a href="<{$xoops_url}>/modules/<{$lang_moduledirname}>/admin/entry.php?op=mod&entryID=<{$reqentries.id}>"><{$reqentries.linktext}></a>
                    &nbsp;
                <{/foreach}>
            </div>
        </fieldset>
    </div>
<{else}>
    <div class="clearer2">
        <fieldset>
            <legend><{$smarty.const._MD_LEXIKON_REQ}></legend>

            <div class="request">
                <b><{$smarty.const._MD_LEXIKON_REQ}></b>
                <{if $wehavereqs == '0'}><{$smarty.const._MD_LEXIKON_NOREQ}>
                <{else}>
                    <br>
                    <span style="font-size:80%;"><{$smarty.const._MD_LEXIKON_REQUESTSUGGEST}></span>
                    <br>
                <{/if}>
                <{foreach item=reqentries from=$blockR.reqstuff}>
                    <a href="<{$xoops_url}>/modules/<{$lang_moduledirname}>/submit.php?suggest=<{$reqentries.id}>"><{$reqentries.linktext}></a>
                    &nbsp;
                <{/foreach}>
            </div>
        </fieldset>
    </div>
<{/if}>
<{if $syndication == true}>
    <div align="center" class="clearer" style="padding: 4px;"><br><br>
        <a href="rss.php" title="recent glossary definitions"><img src="assets/images/rss.gif" ALT="RSS"
                                                                   border="0"/></a>
    </div>
<{/if}>
<br>
<br>
<{include file='db:system_notification_select.tpl'}>

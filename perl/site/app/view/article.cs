<?cs include:"elements/header.cs" ?>
    <div class="article">
        <h1>Home page</h1>
        <p> Welcome </p>
        <article id="editable" <?cs if:#logged_in ?>contenteditable="true"<?cs /if ?>>
            <fieldset>
                <input id="aid" type="hidden" value="<?cs var:article.aid  ?>" />
                <input id="_id" type="hidden" value="<?cs var:article._id  ?>" />
                <legend id="title"> <?cs var:article.title  ?></legend>
                <span id="page"> <?cs var:article.page ?> </span>
                <br /> 
                by <i> <?cs var:article.author  ?> </i>
            </fieldset>
            <button id="save" onclick="jQuery.article.save();" style="display:none">Save</button>     
            <span id="has_saved"></span>       
        </article>
    </div>
    <div class="feature">
     <ul>
     <?cs each:article = related ?>
       <li><a href="/article/id/<?cs var:article.aid ?>"><?cs var:article.title ?></li>
     <?cs /each ?>
     </ul>
    </div>
<?cs include:"elements/footer.cs" ?>
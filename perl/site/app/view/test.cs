<?cs include:"elements/header.cs" ?>


<div class="article">
<h1>Home page</h1>

Welcome <?cs var:name ?> - your currency is <?cs var:money ?> 

<?cs each:item = items ?>
 <fieldset class="roundcorner center half"> 
  <legend>  <?cs var:item.reg_plate  ?> - <?cs var:item.make  ?> - <?cs var:item.model  ?>  </legend>
   <h2>bids</h2>
   <div id="table" >
    <?cs each:bid = item.bids ?>
      
          <div class="row">
            <span class="cellhead"> <?cs var:bid.user  ?> </span> 
            <span class="cell"><?cs var:bid.amount  ?> </span>
          </div>
          
    <?cs /each ?>
    </div>   
    <br />
  </fieldset>
<?cs /each ?>

</div>
<div class="feature">
 feature
</div>
<?cs include:"elements/footer.cs" ?>
<?cs include:"elements/header.cs" ?>

    <div class="article">
    <h1>Subscribe</h1>
    <p>
      Thanks for choosing to subscribe
    </p>
       
    <p> 
    <fieldset class="roundcorner center half">
      <legend>Enter your details below</legend>
      
      <form method="post" action="/subscribe/">
         <input type="hidden" name="rt" value="subscribe" />
         
         <div id="table" >
          <div class="row">
            <span class="cellhead">Login</span>
            <span class="cell"><input type="text" name="name" class="roundcorner" /></span>
          </div>
          <div class="row">
            <span class="cellhead">Email</span>
            <span class="cell"><input type="text" name="email" class="roundcorner" /></span>           
          </div>
          <div class="row">
            <span class="cellhead">Password</span>
            <span class="cell"><input type="password" name="pass" class="roundcorner" /></span>
          </div>
          <div class="row">
            <span class="cell"></span><span class="cell"><input id="submit" type="submit" value="Subscribe" /></span>
          </div>  
        </div>
        
      </form>
      
    </fieldset>
    </p>
   
    <p>
      <?cs if:#success ?>
         Thank you your subscription succeeded.   
      <?cs /if ?>
      <?cs if:#user_exists ?>
         Sorry user already exists.
      <?cs /if ?>
      <?cs if:#failed ?>
         Sorry something went wrong.
      <?cs /if ?>
    </p>
   
    </div>
    <div class="feature">
     feature
    </div>
    
<?cs include:"elements/footer.cs" ?>
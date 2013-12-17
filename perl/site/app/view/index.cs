<?cs include:"elements/header.cs" ?>
    <div class="article">
    <h1><?cs var:hostname  ?></h1>
    <p>
    <?cs if:login_box ?>
        <?cs var:msg  ?>
      <ul>
       <li><a href="/">Home</a></li>
       <li><a href="http://balance-test.com/article/">Home</a></li>
       <li><a href="http://www.balance-test.com/article/">Home</a></li>
       <li><a href="http://balance-test.com">Home</a></li>
       <li><a href="http://www.balance-test.com">Home</a></li>
      </ul>

    <?cs /if ?>
    
    <?cs if:logged_in ?>
        Welcome <?cs var:login ?> on <?cs var:hostname  ?>
    <?cs /if ?>
    </p>

    </div>
    <div class="feature">
    <?cs if:login_box ?>
     <form method="POST" action="/">
       <div id="table" >
          <div class="row">
            <span class="cellhead">Email</span>
            <span class="cell"><input type="text" name="email" class="roundcorner" size="9"/></span>           
          </div>
          <div class="row">
            <span class="cellhead">Password</span>
            <span class="cell"><input type="password" name="pass" class="roundcorner" size="9" /></span>
          </div>
          <div class="row">
            <span class="cell"></span><span class="cell"><input id="submit" type="submit" value="Login" /></span>
          </div>  
        </div>
     </form>
    <?cs /if ?>
    <div>
      <ul>
       <li><a href="/">Home</a></li>
       <li><a href="http://balance-test.com/article/">Home</a></li>
       <li><a href="http://www.balance-test.com/article/">Home</a></li>
       <li><a href="http://balance-test.com">Home</a></li>
       <li><a href="http://www.balance-test.com">Home</a></li>
      </ul>
    </div>
    </div>
<?cs include:"elements/footer.cs" ?>

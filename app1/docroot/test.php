<?php

require('pulldata.php');

/**
 * Some simple PHPUnit testing for reading / writing.
 */

class UnitTests extends PHPUnit_Framework_TestCase {

      public function setUp(){}
	  
      public function tearDown() {}
      
      public function testWrite() {
	  	  $twitter_args = array(
	  	        0 => 'pulldata.php',
	  	        1 => 'Bobby',
	  	        2 => 'file'
	  	  );
	  	
	  	  $this->twitter = new TwitterFeed($twitter_args);
	  	  $this->assertFileExists($this->twitter->filename);
      }
      
      public function testRead() {
      	  $twitter_args = array(
	  	        0 => 'pulldata.php',
	  	        1 => 'Bobby',
	  	        2 => 'read'
	  	  );
	  	  
	  	  $this->twitter = new TwitterFeed($twitter_args);	  	  
	  	  $this->assertFileExists($this->twitter->filename);   
	  	   
	  	  $data = $this->twitter->testData;
	  	  $this->assertStringMatchesFormat('%a', $data);
	  	   
      }
      
      public function testReadRegex() {
      	  $twitter_args = array(
	  	        0 => 'pulldata.php',
	  	        1 => 'Bobby',
	  	        2 => 'read',
	  	        3 => 'That one wins'
	  	  );
	  	
	  	  $this->twitter = new TwitterFeed($twitter_args);
	  	  $this->assertFileExists($this->twitter->filename);
	  	       
	  	  $data = $this->twitter->testData;
	  	  
	  	  $this->assertCount(sizeof($data), $data);
	  	  $this->assertGreaterThan(0, sizeof($data));
	  	  $this->assertContains('Calling it, folks. That one wins.', $data);
      }
      
}

new UnitTests();

?>      
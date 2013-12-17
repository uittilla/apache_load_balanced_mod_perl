<?php

error_reporting(0);

/**
 * Write a PHP script which is to be executed from the command line like this: "php pulldata.php [username]".
 * The PHP script will pull JSON from https://api.twitter.com/1/statuses/user_timeline.json?screen_name=[username] 
 * and write the content of all of the tweets into a file called [username].txt
 * Only the content ("text") of the tweets are needed. It doesn’t matter how you separate out the different tweets (maybe a few line breaks).
 * If the file already exists it should overwrite with newer content, not append the tweets to the list.
 * Although a simple test, thought should be given to the structure of the application and how easy it will be to extend in the future
 * (for example, the ability to write to a database, pull information from a different service..etc.)
 */

/**
 * Storage Parent of TwitterFeed
 * Storage class for fs and db interactions
 * Data storage handled here
 */
class Storage { 

    
    /**
     * File handler
     * @access public 
     */
    public $fh;
    
    /**
     * Filename to user for saving etc
     * @access public 
     */
    public $filename;
        
    /**
     * Array of accumalated errors
     * @access public
     */
    public $errors = array();
    
    /**
     * Default constructor for Storage and TwitterFeed
     * @return null 
     * @access public 
     * @param  $args command line args for username and storage type
     */
    public function __construct ($args = null) {
        $this->worker($args);                                            # TwitterFeed::fetch();
    }   
    
    /**
     * Open a new file handle
     * @return bool (true false)
     * @throws Exception file error exception 
     * @access public 
     */
    public function openFile ($flag = "w+") {                            # Opens a new file handle
        $this->filename = join("", array($this->user, ".txt"));          # Creates the filename
        
        if(!$this->fh = fopen($this->filename, $flag)){                  # Calls fopen
            throw new Exception("Error opening file $this->filename $this->delimiter"); 
            return false;
        } 
        
        return true;                                                     # Signals success
    }
    
    /**
     * Write data to given file handle
     * @return bool (true false)
     * @throws Exception file writing exception 
     * @access public 
     */
    public function writeFile ($text) {                                  # Write given text to file
        $outText = join(array("", $text, "\n"));                         # Format text for writing  
        
        if(!fwrite($this->fh, $outText)) {                               # File write check
            throw new Exception("Error writing to $this->filename $this->delimiter");
            return false;
        }
        
        return true;                                                     # Signals success
    }
    
    /**
     * Read data to given file handle
     * @return bool (true false)
     * @throws Exception file writing exception 
     * @access public 
     */ 
    public function readFile () {
        if(!$this->fh) {
            $this->openFile("r");
        }
        
        $contents = "";
        
        if( !$contents = fread($this->fh, filesize($this->filename) ) ) {
            throw new Exception("Error reading $this->filename $this->delimiter");
            return false;               
        } 
        
        $this->closeFile();
        
        return $contents;
    }
    
    public function readDatabase () {
        return "select * from tweets where name = '$this->user' $this->delimiter";
    }
    
    /**
     * Write our entries to the database
     * @return null 
     * @access public 
     */
    public function writeDatabase($text) {
       return "insert into tweets (name, text) values ('$this->user', '$text'); $this->delimiter";
    }   
    
    /**
     * Close a current file handle
     * @return null 
     * @access public 
     */
    public function closeFile() {
        if($this->fh) {
            fclose($this->fh);
        }
    }
}

/**
 * TwitterFeed extends Storage
 * Fetching and formatting done within this class
 */
class TwitterFeed extends Storage {
    
    /**
     * FEED URL
     * 
     */
    const FEED_URL      = "https://api.twitter.com/1/statuses/user_timeline.json?screen_name=";
    const BAD_STORAGE   = "Undefined storage type found, please choose 'file' or 'db'\n";   
    const NO_ENTRIES    = "Feed has no entries";
    const MESSAGE_SAVED = "Messages written\n";

    /**
     * Deliminator for line breaks (cmd or web)
     */
     public $delimiter = "\n"; 

    /**
     * Container for returned json data
     * @access public 
     */
    public $json;
    
    /**
     * Read flag signifies we with to read data
     * @access public
     */
    public $read = false;   
    
    /**
     * Feed/ File username
     * @access public
     */
    public $user;
        
    /**
     * Complete feed URI + username
     * @access public
     */
    public $feed;

    /**
     * Optional search pattern for use with read
     * @access public
     */
    public $pattern;
    
    /**
     * Storage type (file | db)
     * @access public
     */
    public $storage = "file";
    
    /**
     * test data container for phpUnit
     * @access public
     */    
    public $testData;
    
    /**
     * Kick off our worker process
     * @return null 
     * @access public
     */ 
    public function worker($args) {
        
        if(!empty($args)) {
            $this->cmdLineArgs($args);                               # args[1] username, args[2] storage type
        }
        
        if(!empty($_GET)) {
            $this->delimiter = "<br />";
            $this->getVars();
        }
        
        if(!$this->read) {
            $this->feedAction();                                     # Obtain and save our feeds            
        } else {
            $this->showFeed();                                       # Shows feed contents          
        }       
            
        if($this->errors) {                                          # If we have accumalated any errors
            $this->showErrors();                                     # Display them             
        }           
    }
    
    /**
     * parse and assign cmd line args
     * @return null 
     * @access public
     * @param  $args command line args (username, storage)
     */
    public function cmdLineArgs ($args) {
        
        $this->user = $args[1];                                      # Required username
        
        if(!empty($args[2])) {                                       # Optional storage type 
            switch($args[2]) {
               case "file":
               case "db":
                 $this->storage = $args[2];
               break;   
               case "read":
                 $this->read = true;
               break;
               default:
                 $this->errors[] = TwitterFeed::BAD_STORAGE;
            }
        }
        
        if(!empty($args[3])) {
            $this->pattern = $args[3];
        }
    }
    
    public function getVars () {
        if(!empty($_GET['user'])) {
            $this->user = $_GET['user']; 
        }   
        
        if(!empty($_GET['storage'])) {
            
            switch($_GET['storage']) {
               case "file":
               case "db":
                 $this->storage = $_GET['storage'];
               break;   
               case "read":
                 $this->read = true;
               break;
               default:
                 $this->errors[] = TwitterFeed::BAD_STORAGE;                
            }
        }
        
        if(!empty($_GET['pattern'])) {
            $this->pattern = $_GET['pattern'];
        }
    }
    
    /**
     * Act on our feed, save either to file or database
     * @return null 
     * @access public
     * @see    TwitterFeed::getFeed()
     * @see    Storage::openFile();
     * @see    Storage::writeFile();
     * @see    Storage::closeFile();
     * @see    Storage::writeDatabase(); 
     */
    public function feedAction () {
        
        try {
            $data = $this->getFeed();                                # Obtain our user feed
        } catch (Exception $e) {
            $this->errors[] = $e->getMessage();                      # We can catch our exceptions and insert into errors
        }       
        
        if(!empty($data)) {                                          # Make sure we have some data
            if($this->storage == 'file') {                           # Storage type of file
                try {
                    if($this->openFile()) {                          # We want to store data on the fs
                        foreach($data as $entry) {                   # Use the username as file name
                            $this->writeFile($entry);                # Write each text entry yo local file
                        }
                    }
                    
                    $this->closeFile();                              # Closes our file handle
                    
                    print TwitterFeed::MESSAGE_SAVED;                # Otherwise display success
                                    
                } catch(Exception $e) {
                    $this->errors[] = $e->getMessage();          
                }       
              
            } else {
                foreach($data as $entry) {                           # Use the username as file name
                    $result = $this->writeDatabase($entry);          # Saves tweets to database
                    print $result;
                }                
            }
        
        } else {
            $this->errors[] = TwitterFeed::NO_ENTRIES;
        }       
    }
    
    /**
     * Obtains a given twitter feed
     * @return null 
     * @access public
     */ 
    public function getFeed () {
        
        $this->feed = TwitterFeed::FEED_URL . $this->user;           # Complete the feed URL 
        $tweets     = array();                                       # Feed contents place holder
        
        if($this->json = file_get_contents($this->feed) ) {          # Get the feed contents
        
            if( !empty($this->json) ) {                              # Make sure we havea  valid feed 
                foreach(json_decode($this->json) as $entry) {        # Decode and pass through as entry object              
                    if( !empty($entry->text) ) {                     # Ensure feed object has a text entry  
                        $tweets[] = $entry->text;                    # Push into our local tweets area if true
                    }
                }
            }
                
            return !empty($tweets) ? $tweets : array();              # Return our tweets or an empty array
        
        } else {
            
            throw new Exception ("Failed to fetch $this->feed $this->delimiter");   # Throw exception on failure to get feed
        }
    }
    
    /**
     * Display data from read request
     * @return null 
     * @access public
     * @param $data data from either file or database
     */         
    public function showfeed () {
        
        $data = "";
        
        try {                                                           
            $data = $this->readFile();                                # Attempt to read data from file 
        } catch (Exception $e) { 
            $this->errors[] = $e->getMessage();                       # Throws Exception on failure         
        }

        if(empty($data)) {                                            # If we have no data 
            $this->errors = array();
            $data = $this->readDatabase();                            # Try reading database instead
        }
        
        if( !empty($data) ) {                                         # Check again to see if we have results 
            
            $this->testData = $data;
            
            if(!is_array($data)) {                                    # fread returns a string
                $tmp = explode("\n", $data);                          # make an array on line feed \n 
                $data = $tmp;
            } 
            
            if($this->pattern) {                                      # Optional tweet searches
                print "Scanning for '$this->pattern' $this->delimiter";
                
                $regex = "/$this->pattern/";                          # See if we can pattern match a tweet
                $matches = preg_grep($regex, $data);                  # Make an array of entriers if so
    
                if($matches) {                                        # If we have matches show them
                    $this->testData = $matches;
                    $this->display($matches);
                }
                
            } else {
                $this->display($data);                                # Or just display the entire tweets 
            }       
        }
    }

    /**
     * Display data from read request
     * @return null 
     * @access public
     * @param $data data from either file or database
     */     
    public function display($data) {
        foreach($data as $k=>$v) {
            print "$k, $v $this->delimiter";            
        }       
    }

    /**
     * Parse errors
     * @return null 
     * @access public
     */ 
    public function showErrors() {
        foreach($this->errors as $error) {
            print "** $error $this->delimiter";
        }
    }
}

/**
 *  Make sure we have a username passed in
 */
if(!empty($argc)) { 
   
  if($argc < 2) {
    print "Usage pulldata.php <username> optional(<storage: file|db|read>) optional(<search pattern>)\n";
    exit(0);
  }
  
  new TwitterFeed($argv);
  
} else {
  # uncommented for additional web usage
  # keep commented for testing    
  # new TwitterFeed();
}



?>

use strict;
use warnings;
use vars qw(@ISA);

use lib qw(/home/www/apache_mod_perl/perl);
use lib qw(/home/www/apache_mod_perl/perl/site);
use lib qw(/export/mol-uk/modules);

use Text::ClearSilver (); 
use Data::Dumper (); 
use File::Basename (); 
use CGI (); 
use Data::Dumper (); 
use MongoDB (); 
use MongoDB::OID (); 
use Digest::MD5 qw(md5 md5_hex md5_base64);  
use File::Basename (); 
use Cwd (); 
use Date::Parse (); 
use POSIX (); 
use HTML::Entities (); 

use app::controller::Controller (); 
use app::model::Router (); 
use app::model::Register (); 
use app::model::Db (); 

  # enable if the mod_perl 1.0 compatibility is needed
  # use Apache2::compat ();
  
  # preload all mp2 modules
  # use ModPerl::MethodLookup;
  # ModPerl::MethodLookup::preload_all_modules();
  
use ModPerl::Util (); #for CORE::GLOBAL::exit
 
use Apache2::RequestRec (); 
use Apache2::RequestIO (); 
use Apache2::RequestUtil (); 
  
use Apache2::ServerRec (); 
use Apache2::ServerUtil (); 
use Apache2::Connection (); 
use Apache2::Log (); 

use CGI::Session ();
  
use APR::Table (); 
  
use ModPerl::Registry (); 
  
use Apache2::Const -compile => ':common';
use APR::Const -compile => ':common';

1;

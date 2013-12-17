 #file:MyApache2/Rocks.pm
#----------------------
package MyApache2::Rocks;
  
use strict;
use warnings;  

use Apache2::RequestRec ();
use Apache2::RequestIO ();
use Apache2::Request ();  
  
use Apache2::Const -compile => qw(OK);
  
sub handler {
    my ($r) = shift;
    my $self = bless {};

    $r->content_type('text/plain');    
    #my $req = Apache2::Request->new($r);
    
    print "Mod perl rocks";

    return Apache2::Const::OK;
}
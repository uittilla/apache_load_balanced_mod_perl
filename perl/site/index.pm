#
#----------------------
package site::index;
  
use strict;
use warnings;
  
use Apache2::RequestRec ();
use Apache2::RequestIO ();
use Apache2::Request ();  
  
use Apache2::Const -compile => qw(OK);
  
sub handler {
    my ($r) = shift;
    my $self = bless {};
    $r->content_type('text/html');

    $self->{r} = $r;
    $self->worker();

    return Apache2::Const::OK;
}

sub worker {
    my $self = shift;

    use Data::Dumper;

    # Objects
    $self->{cgi}     = new CGI();                                   # CGI instance
    
    $self->{router}   = new app::model::Router();                    # Router instance
    $self->{register} = new app::model::Register();                  # Register instance
    $self->{db}       = new app::model::Db();                        # Db instance  
    
    $self->{hostname} = $self->{r}->hostname();                      # show what app we are on
    
    # Paths
    $self->{docroot}  = File::Basename::dirname(__FILE__);
    $self->{docroot}  =~ s{/docroot}{}; 
    $self->{viewroot} = $self->{docroot} . "/app/view/";
    $self->{modroot}  = $self->{docroot} . "/app/model/";
    $self->{conroot}  = $self->{docroot} . "/app/controller/";


    #print Dumper $self;


    if(!defined $self->{cgi}->param('rt')) {                         # mod perl looses home index (/) 
        $self->{cgi}->append(-name=>'rt', -values=>['index']);
    }

    print Dumper $self->{cgi}->param('captcha');

    if( $self->{cgi}->param() ) {                                    # map cgi params into our registry module       
         foreach($self->{cgi}->param()) {                            # ? + & style urls 
            $self->{register}->set( $_, $self->{cgi}->param($_) );
         }
       
         if($self->{cgi}->param('rt') =~ m/(.*)\/(.*)/) {            # clean URL's /param/value/ style
             my @bits = split(/\//, $self->{cgi}->param('rt'));
             $self->{register}->set('rt', $bits[0]);
             for(my $i=1, my $cnt = @bits; $i<$cnt; $i++) {
                if($i % 2 == 0) { $self->{register}->set($bits[$i-1], $bits[$i]); }
             }
         }
    }
    
    my $session;
    my $sid;
    
    if( defined $self->{cgi}->cookie("CGISESSID") ) {
        $sid = $self->{cgi}->cookie("CGISESSID");
        $session = new CGI::Session(undef, $sid, {Directory=>'/tmp'});

    } else {
        $session = new CGI::Session(undef, $sid, {Directory=>'/tmp'});
        my $cookie = $self->{cgi}->cookie(CGISESSID => $session->id);
        
        print $self->{cgi}->header( -cookie=>$cookie );
    }     
    
    $self->{session} = $session;
        
    $self->{router}->load($self);
    
  #  print STDERR Dumper $self;
      	
}

1;



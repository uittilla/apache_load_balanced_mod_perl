=head1 NAME 

app::controller::indexController - Index controller 

=head1 SYNOPSIS

  use app::controller::Controller;
  @ISA = qw(app::controller::Controller);
  index
  
=head1 DESCRIPTION

  Index controller 
=head2 Methods
=cut

package app::controller::indexController;

=over 4

=item * $object->index(template, route, vars)

   Abstract method called from Router.pm
   
   Params:
      template: template to parse
      route   : controller name  (see Router.pm)
      vars    : application vars (see Registry.pm)
             
=cut

use app::controller::Controller;

@ISA = qw(app::controller::Controller);

use Digest::MD5  qw(md5 md5_hex md5_base64);

sub index {
    my ($self) = shift;
    my $csvars = {"login_box" => 1};
    my $db     = $self->{db}->getInstance("moluk");
    my $users  = $db->users;
    my $r      = $self->{r};
      
    # do something
    if(defined $self->{register}->get('email') && defined $self->{register}->get('pass') ) { 
    	my $pass  = md5_hex($self->{register}->get('pass'));
    	
    	my $user = $users->find({
        	        "email"     => $self->{register}->get('email'), 
        	        "password"  => $pass 
        });
        
        if(defined $user) {
            while (my $doc = $user->next) {
            	if(defined $self->{session}) {

            		$csvars = {"hostname"=>$self->{hostname}, "logged_in" => 1, "login" => $doc->{'login'} };
            		$self->{session}->param("user", $doc);
			    }
	        }
        } else {
        	$csvars = {"hostname"=>$self->{hostname}, "login_box" => 1, "msg" => "Login failure"};
        }
        
    } else {
    	
    	if(defined $self->{session}->param("user")) {
    		
    		my $user = $self->{session}->param("user");
    		$csvars = {"hostname"=>$self->{hostname}, "logged_in" => 1, "login" => $user->{'login'} };
    	} else {
    		
    		$csvars = {"hostname"=>$self->{hostname}, "login_box" => 1, "msg" => "Please login mo"};
    	}    	
    } 

    $self->process($self->{tpl}, $csvars);      	    
}

1;
=back

=head1 AUTHOR

(Ibbo)

=head1 COPYRIGHT

Copyright 2010.  All rights reserved.

Do as you will.

=head1 SEE ALSO

perl(1).
app::controller:Controller(1)
app::model::Router(1).
app::model::Registry(1).

=cut 

=head1 NAME 

app::controller::subscribeController - subscribe controller 

=head1 SYNOPSIS

  use app::controller::Controller;
  @ISA = qw(app::controller::Controller);
  index
  
=head1 DESCRIPTION

  Index controller 
=head2 Methods
=cut

package app::controller::subscribeController;

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

sub index {
    my ($self) = shift;
    my $csvars = {};
    # do something
    my $db    = $self->{db}->getInstance("moluk");
    my $users = $db->users;
    my $exists = 0;
    
    if(defined $self->{register}->get('name') && defined $self->{register}->get('email') && defined $self->{register}->get('pass') ) 
    {
       my $login = $self->{register}->get('name');
       my $email = $self->{register}->get('email');
       
       my $pass  = Digest::MD5::md5($self->{register}->get('pass'));
       
       my $user = $users->find({"login" => $login, "email" => $email});
       
       while (my $doc = $user->next) {
           $csvars->{user_exists} = defined ($doc->{'login'}) ? 1 : 0;
       }
       
       if(!$csvars->{user_exists}) { 
          my $id = $users->insert({"login" => $login, "email" => $email,"password" => $pass});
          $csvars->{failed} = !defined ($id) ? 1 : 0; 
          $csvars->{success} = defined ($id) ? 1 : 0;
       }
    } 
    
    #$users->drop;
    
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

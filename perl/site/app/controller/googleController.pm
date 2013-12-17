=head1 NAME

app::controller::errorController - Error controller 

=head1 SYNOPSIS

  use app::controller::Controller;
  @ISA = qw(app::controller::Controller);
  index


=head1 DESCRIPTION

  Error controller class (format error page) 

=head2 Methods
=cut
  
package app::controller::googleController;

use app::controller::Controller;
@ISA = qw(app::controller::Controller);


=over 4
  
=item * $object->index(template, route, vars)

   Abstract method called from Router.pm
   
   Params:
      template: template to parse
      route   : controller name  (see Router.pm)
      vars    : application vars (see Registry.pm)
             
=cut

sub index {
	
    my ($self) = shift;
    my $csvars = {};
    
    if(defined $self->{register}->get('captcha')) {
        $csvars->{result} = 1;
        $csvars->{resultSet} = $self->{register}->get('captcha'); 
        $csvars->{nothing} = 0;
    } else {
        $csvars->{result} = 0;
        $csvars->{nothing} = 1;
    }
    
    $self->process( $self->{tpl}, $csvars );
}
1;
=back

=head1 AUTHOR

(Ibbo)

=head1 COPYRIGHT

Copyright 2010.  All rights reserved.

Do as you will

=head1 SEE ALSO

perl(1).
app::controller:Controller(1)
app::model::Router(1).
app::model::Registry(1).

=cut 

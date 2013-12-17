=head1 NAME 

app::controller::testController - test controller 

=head1 SYNOPSIS

  use app::controller::Controller;
  @ISA = qw(app::controller::Controller);
  index
  
=head1 DESCRIPTION

  Index controller 
=head2 Methods
=cut

package app::controller::testController;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use Data::Dumper;

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
   
    $csvars->{money} = $self->{register}->get('money');
    $csvars->{name}  = $self->{register}->get('name');
    
    my $db   = $self->{db}->getInstance("simulcast");
    my $sims = $db->simulcasts;
    
    $sims->ensureIndex({"bids.user" => "1"});
    my $all_vehicles = $sims->find({"bids.user" => qr/(.*)/i});
    
    #my $all_vehicles = $sims->find();
   
    my $records; 
    
    while (my $doc = $all_vehicles->next) {

    	push(@{$records}, $doc);
    }
    
    $csvars->{items} = $records;
    
    #print Dumper $csvars->{items};
    
    $self->process($self->{tpl}, $csvars);
    $db->run_command({drop =>$users});                  
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

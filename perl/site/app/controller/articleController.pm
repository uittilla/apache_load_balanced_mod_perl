=head1 NAME 

app::controller::articleController - article controller 

=head1 SYNOPSIS

  use app::controller::Controller;
  @ISA = qw(app::controller::Controller);
  index
  
=head1 DESCRIPTION

  Index controller 
=head2 Methods
=cut

package app::controller::articleController;
use HTML::Entities;
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
    
    if(defined $self->{register}->get('mode')) {
      my $mode = $self->{register}->get('mode');
      
      if($mode eq "save") {
      	 $self->saveArticle(); 
      }
      
    } else {
    	
    	 $csvars = $self->showArticle();
    }
   
    $self->process($self->{tpl}, $csvars);              
}

sub saveArticle {
	my $self = shift;
	
	my $params = { "db"    => $self->{db},
		           "title" => $self->{register}->get('title'),
		           "page"  => $self->{register}->get('page'),
		           "id"    => $self->{register}->get('aid'),
		           "_id"   => $self->{register}->get('_id')
	};
	
	my $articles = $self->loadClass("articles", 1, $params );
	
	$articles->editArticle();
	
	return 1;
}

sub showArticle {
	my $self = shift;
    
    $self->{id} = 1001;
    
    if(defined $self->{register}->get('id')) {
        $self->{id} = $self->{register}->get('id');
    }    

    my $articles = $self->loadClass("articles", 1, { "db" => $self->{db}, "id" => $self->{id} } );

   # $articles->createArticle();
    
    $article = $articles->getArticle();
    
    $article->{'page'} = HTML::Entities::decode($article->{'page'});
    #$article->{'page'} =~ s/\<\/p\>/\<\/p\>\<br \/>/g;

    $csvars->{article} = $article;

    my $related = $articles->getReleated($article->{'type'});

    $csvars->{related} = $related;
    
    return 	$csvars;
	
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

package app::model::articles;

sub new {
    my ($classname, $params) = @_;
    my $self = bless {},$classname;

    $self->{db}       = $params->{db}->getInstance("moluk");
    $self->{id}       = $params->{id};
    $self->{articles} = $self->{db}->articles;

    $self->{title} = $params->{title};
    $self->{page}  = $params->{page};
    $self->{id}    = $params->{id};
    $self->{_id}   = $params->{_id};

    return $self;
} 

sub getArticle {
   my $self     = shift;
   my $text     = "Ha, no such article";
 
   my $article = $self->{articles}->find({"aid" => "$self->{id}"});
   while (my $doc = $article->next) {
        return $doc;
   }
   
   return $text;
}

sub createArticle {
	my $self=shift;
	
	#my $article = $self->{articles}->find();
	#my $count = $articles->count();
	
	$self->{articles}->insert({"aid" => "1003", "title" => "And finally", 
		              "page" => "&lt;p&gt;Mr Noyce, known as Bob, was one of the first to work in the field before the famous technology heartlands in California emerged.He founded Intel with Gordon Moore in 1968 and originally planned to call the firm Moore Noyce but thought it sounded like more noise.&lt;/p&gt;&lt;p&gt;The electronics engineer, who also ran the firm Fairchild Semiconductor, invented the integrated chip, which paved the way for the microprocessors used in modern computers.Mr Noyce died in 1990 of heart failure at the age of 62.&lt;/p&gt;&lt;p&gt;The doodle on Googles home page pays tribute to Mr Noyces work on the microchip with an image of an electronic chip and the search engines name on the circuit board.&lt;/p&gt;",
		              "inserted" => "20111212 13:28:52", 
		              "author" => "M Ibbotson", 
		              "updated" => "", 
		              "views" => "0", 
		              "type" => "100"
	});
	
	print "Error " . Data::Dumper::Dumper ($self->{articles}->getLastErrorObj());
	print "WHEY";
	
	my $article = $self->{articles}->find();
	while (my $doc = $article->next) {
        print STDERR Data::Dumper::Dumper $doc;
   }
}

sub getReleated {
	my ($self, $type) = @_;
	
	my $rel;
	
	$self->{articles}->ensureIndex({"type" => "1"});
	
    my $related = $self->{articles}->find({"type" => $type});
    while (my $doc = $related->next) {
    	push(@{$rel}, $doc);
    }
    
    return $rel;	
}

sub editArticle {
    my $self=shift;	
    #print STDERR "EDITING " . $self->{id} . " " . $self->{title} . " " . $self->{page};
     
    $self->{articles}->update({ "aid" => $self->{id} }, {'$set' => {"title" => $self->{title}, "page" => $self->{page} } });
}

1;
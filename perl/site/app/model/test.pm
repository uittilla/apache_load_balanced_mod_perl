package app::model::test;

sub new {
    my ($classname, $params) = @_;
    my $self = bless {},$classname;

    $self->{db}       = $params->{db}->getInstance("moluk");
    $self->{id}       = $params->{id};
    $self->{fortunes} = $self->{db}->fortunes;
    
    
    return $self;
} 

sub getText {
   my $self     = shift;
   #my $db       = $self->{db}->getInstance("moluk");
   
   my $text     = "Ha, no such fortune";
   
   #my $entries = $fortunes->find();
   #print STDERR "Count " . $entries->count();
 
   my $fortune = $self->{fortunes}->find({"fid" => "$self->{id}"});
  
   while (my $doc = $fortune->next) {
        return $doc->{'text'};
   }
   
   return $text;
}

1;
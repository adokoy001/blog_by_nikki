package NikkiUserFunction;
use strict;
use warnings;
use utf8;
use Exporter 'import';
our @EXPORT = qw/entry_filter archive_generator tag_index_generator/;

sub entry_filter(){
  my $input = shift;
  ## write filter.
  my $output = $input;
  return $output;
}

sub archive_generator(){
  ## this will work on _=_USER_DEFINED_ARCHIVE_=_ label.
  my $archive = shift;
  my $year_month;
  foreach my $entry (@$archive){
      my ($year,$month) = (split('/',$entry->{www_path}))[2,3];
      if(defined($year_month->{$year}) and defined($year_month->{$year}->{$month})){
	  push(@{$year_month->{$year}->{$month}},$entry);
      }else{
	  $year_month->{$year}->{$month} = [$entry];
      }
  }
  my $archive_list = "";
  foreach my $year (sort {$b <=> $a} keys %$year_month){
      $archive_list .= "<p> $year </p>\n";
      foreach my $month ( sort {$b <=> $a} keys %{$year_month->{$year}} ){
	  $archive_list .= "<ul> $year/$month \n";
	  foreach my $entry (@{$year_month->{$year}->{$month}}){
	      my ($date) = (split('/',$entry->{www_path}))[4];
	      my ($yyyy,$mm,$dd) = (split('_',$date))[0,1,2];
	      $archive_list .= "  <li> $yyyy-$mm-$dd : <a href=\"$entry->{www_path}\"> $entry->{title} </a> - $entry->{summary} </li>\n";
	  }
	  $archive_list .= "</ul>\n";
      }
  }
  return $archive_list;
}

sub tag_index_generator(){
  ## this will work on _=_USER_DEFINED_TAG_INDEX_=_ label.
  my $tag_info = shift;
  ## write tag index html content generator.
  my $body_tag_index .= "<ul>\n";
  foreach my $tmp_tag (sort keys %$tag_info){
    my $tag_link = $tag_info->{$tmp_tag}->{path};
    my $tag_real_path = $tag_info->{$tmp_tag}->{real_path};
    my $tag_counter = $tag_info->{$tmp_tag}->{counter};
    $body_tag_index .= "<li><a href=\"$tag_link\"> $tmp_tag ($tag_counter)</a></li>\n";
  }
  $body_tag_index .= "</ul>\n";
  return $body_tag_index;
}

1;

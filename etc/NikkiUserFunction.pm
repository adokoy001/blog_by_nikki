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
  my $archive_list = "";
  $archive_list .= "<ul>\n";
  foreach my $entry (@$archive){
    $archive_list .= "  <li> $entry->{created_at} : <a href=\"$entry->{www_path}\"> $entry->{title} </a> - $entry->{summary} </li>\n";
  }
  $archive_list .= "</ul>\n";
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

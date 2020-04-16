package NikkiUserFunction;
use strict;
use warnings;
use utf8;
use Exporter 'import';
our @EXPORT = qw/entry_filter archive_generator tag_index_generator related_content/;

sub escape_html {
    my $input = shift;
    if(defined($input) and $input ne ""){
	$input =~ s/&/&amp;/msg;
	$input =~ s/</&lt;/msg;
	$input =~ s/>/&gt;/msg;
    $input =~ s/"/&quot;/msg;
	return $input;
    }else{
	return "";
    }
}

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
      $archive_list .= "<h2> $year </h2>\n";
      foreach my $month ( sort {$b <=> $a} keys %{$year_month->{$year}} ){
	  $archive_list .= "<ul> <b>$year/$month</b>\n";
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

sub related_content(){
    my $tag_related = shift;
    my $related_list = "<ul>\n";
    foreach my $entry (@$tag_related){
	my ($date) = (split("/",$entry->{path}))[4];
	my ($yyyy,$mm,$dd) = (split("_",$date))[0,1,2];
	$related_list .= "<li> $yyyy-$mm-$dd : <a href=\"" . $entry->{path} . "\">"
	    . &escape_html($entry->{title}) . "</a></li>\n";
    }
    $related_list .= "</ul>\n";
    return $related_list;
}

sub whats_new(){
    my $archive = shift;
    my $config = shift;
    my $updates = "";
    my $counter = 0;
    foreach my $entry (@$archive){
	$counter++;
	if($counter > $config->{whats_new}){
	    last;
	}else{
	    $updates .= '<div class="card"><h3 class="card-header"><a href="'.$entry->{www_path}
	    .'">'.$entry->{title}
	    .'</a>'
	    .'</h3><div class="card-body">'
		.&escape_html($entry->{summary})
	    .'</div><div class="card-footer"> CREATED AT: '
		.$entry->{created_at}
	    .'</div></div>';
	}
    }
    return $updates;
}

sub related_tags(){
    my $tmp_tags = shift;
    my $tag_info = shift;
    my $tmp_tag_html = '';
    $tmp_tag_html .= "<ul>\n";
    foreach my $tmp_tag (@$tmp_tags){
	$tmp_tag_html .= "<li> <a href=\"".$tag_info->{$tmp_tag}->{path}."\">".&escape_html($tmp_tag)."</a></li>\n";
    }
    $tmp_tag_html .= "</ul>\n";
    return $tmp_tag_html;
}

1;

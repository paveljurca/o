use strict;
use warnings;
use 5.014;

# core modules

use File::Spec::Functions;
use File::Path 'make_path';
use File::Basename;
use JSON::PP 'decode_json';
use open ':encoding(UTF-8)';
use autodie;

# ==== TODO ====
# 8/17/2017
# [x] template utf8 support (OK)


# ==== MAIN ====
my $msg = {
  err_data      => 'Data is not valid.',
  err_mkdir     => 'Could not create the playlist directory.',
  err_template  => 'Template variable does not map to any JSON key.',
  build         => sub {q({"build":").shift.q(","timestamp":").shift.q("})},
};

# base dir
my $root = catdir(dirname($0), 'oikumena');
# file entries
my $file = {
  # index.html
  index       => catfile('index.html'),
  # make dir
  dir_pl      => catdir('o'),
  # TERM template
  tt_heading  => catfile($root, 'html', 'template', 'term.tt.html'),
  # COURSE template
  tt_item     => catfile($root, 'html', 'template', 'course.tt.html'),
  # VIDEO template
  tt_video    => catfile($root, 'html', 'template', 'video.tt.html'),
  # HEADER html
  html_header => catfile($root, 'html', 'static', 'header.html'),
  # FOOTER html
  html_footer => catfile($root, 'html', 'static', 'footer.html'),
  # JSON file
  data        => catfile($root, 'data', 'oikumena.json'),
};

# === RUN ===

oikumena(data($file->{data}));

# ==============



=head2 oikumena 

Zaznamy prednasek doc. Pince

in: JSON data

=cut

sub oikumena {
  # JSON array
  my $data = shift;

  my %term;
  for my $cursor (@$data) {

    # ---------------------

    # SET to empty for undefined HEADING key

    # ---------------------

    $cursor->{term} //= '';

    # ---------------------

    # CHANGE playlist url for a local filepath

    # ---------------------
   
    my $playlist_filepath = clean_filepath(
        $file->{dir_pl},
        $cursor->{term},
        # use IDENT key or 5 digits for a filename
        $cursor->{ident} || int(rand()*100000)
    ).'.html';
    
    $cursor->{playlist_url} = $playlist_filepath;

    # ---------------------

    # DOM index.html

    # ---------------------
   
    my $DOM = \$term{$cursor->{term}};

    # <!-- TERM -->
    unless ($$DOM) {
      my $html_term = template(read_file($file->{tt_heading}), $cursor);
      push @{ $$DOM }, $html_term;
    }
    
    # <!-- COURSE -->
    my $html_course = template(read_file($file->{tt_item}), $cursor);
    push @{ $$DOM }, $html_course;

    # ---------------------

    # MAKE dir

    # ---------------------

    my $dir_pl = dirname($playlist_filepath);
    
    unless (-d $dir_pl) {
      make_path(
        $dir_pl, { error => \my $err_mkdir }
      ) or err($msg->{err_mkdir});
    }

    # ---------------------

    # WRITE video iframe out

    # ---------------------
    
    my $html_playlist = template(read_file($file->{tt_video}), $cursor);
    
    write_file($html_playlist, $playlist_filepath);
  }

  # ---------------------

  # WRITE index.html out

  # ---------------------

  open my $html, '>', \my $out;

  # HEADER
  say $html read_file($file->{html_header});

  # BODY
  for my $dom (sort_custom(keys %term)) {
    say $html @{ $term{$dom} };
  }

  # FOOTER
  say $html read_file($file->{html_footer});

  close $html;

  write_file($out, $file->{index});

  # done
  say $msg->{build}->('OK', scalar localtime);
}

=head2 clean_filepath

Clean file path

in:   file path list
out:  file path string

=cut

sub clean_filepath {
    my @filepath = @_;
    # turn on ASCII with the "a" modifier
    my $rx_clean = qr|[^[:alnum:]]|a;

    # should be safe on most systems
    return catfile(map {lc s/$rx_clean/_/gr} @filepath);
}

=head2 data

Get JSON data

in:   data file path
out:  JSON string

=cut

sub data {
  open my $in_data, '<', shift;
  binmode $in_data;

  eval {
    no warnings;
    
    # SLURP MODE
    local $/;
    my $data = <$in_data>;

    return decode_json($data);

  } or err($msg->{err_data});
}

=head2 write_file

Write given file

in:   string, file path

=cut

sub write_file {
  my $string   = shift;
  my $filepath = shift;

  # rewrite
  open my $out_file, '>', $filepath;

  # FLUSH BUFFER
  $| = 1;

  # PERLDOC:
  # Change each character of a Perl scalar to/from a series of
  # characters that represent the UTF-8 bytes of each original character.
  utf8::decode($string);

  print $out_file $string;

  # return exit code
  close $out_file;
}

=head2 read_file

Read given file

in:   file path
out:  string

=cut

sub read_file {
  my $filepath = shift;
  
  open my $in_file, '<', $filepath;

  # SLURP MODE
  local $/;
  my $string = <$in_file>;

  close $in_file;

  return $string;
}

=head2 template

Compile template and return html

in:   template string, CURSOR
out:  html

=cut

sub template {
  my $template = shift;
  my $cursor   = shift;

  # REGEX TO MATCH TEMPLATE TAGS AND VARIABLES
  my $rx_template = qr|(?<tag>\[!\s+(?<var>[^ ]+)\s+!\])|s;

  my @tags;
  for (split /[\r\n]/, $template) {
    push @tags, { %+ } while (/$rx_template/gc);
  }

  # COMPILE TEMPLATE
  for my $tt (@tags) {
    my $tag = quotemeta($tt->{tag});
    # set matched VAR to lowercase
    my $var = $cursor->{lc $tt->{var}} || '?';

    $template =~ s/$tag/$var/;
  }

  return $template;
}

=head2 sort_custom

Sort by the latest semester

in:   list of terms
out:  sorted list

=cut

sub sort_custom {
  # sort by terms descending
  return sort {
    my $rx_year = qr/(\d{2})$/;
    my $rx_term = qr/^(.{2})/;

    # set to 1 if there's no match
    my ($year_a) = ($a =~ $rx_year, 1);
    my ($year_b) = ($b =~ $rx_year, 1);

    my ($term_a) = $a =~ $rx_term;
    my ($term_b) = $b =~ $rx_term;

    ($year_b <=> $year_a) == 0 ? $term_a cmp $term_b : $year_b <=> $year_a
  } @_
}

sub err {
  my $msg = shift;

  die qq(ERR: $msg\n);
}

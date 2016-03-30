#!/usr/bin/env perl6
use v6;
use HTTP::UserAgent;
use XML;
use HTML::Entity;
 
my $feed = "http://aws.amazon.com/new/feed/";
my $results = from-xml(HTTP::UserAgent.new.get($feed).content);

sub strip-html($str is copy) {
  $_ = $str;
  $_ ~~ s:g/\<.+?\>//;
  $_;
}

for $results.nodes[0].elements(:TAG<item>) -> $node {
  my $category = $node.elements(:TAG<category>);
  $category ~~ s:g/\<.+?\>//;

  if ($category.contains('general:products')) {
  	my $pubdate = strip-html $node.elements(:TAG<pubDate>);
  	my $title = strip-html $node.elements(:TAG<title>);
  	my $desc = strip-html $node.elements(:TAG<description>);
  	my $link = strip-html $node.elements(:TAG<link>);

    say '### [' ~ $title ~ '](' ~ $link ~ ')';
    say '';
    say '**Category:** ' ~ $category;
    say '**Date:** ' ~ $pubdate.substr(0, 16);
    say '';
    say '' ~ decode-entities $desc;
    say '';
  }
}


#!/usr/bin/env perl6
use v6;
use HTTP::UserAgent;
use XML;
use HTML::Entity;
 
my $feed = "http://aws.amazon.com/new/feed/";
my $results = from-xml(HTTP::UserAgent.new.get($feed).content);

for $results.nodes[0].elements(:TAG<item>) -> $node {
	my $category = $node.elements(:TAG<category>);
	$category ~~ s:g/\<.+?\>//;

  if ($category.contains('general:products')) {
  	my $pubDate = $node.elements(:TAG<pubDate>);
  	$pubDate ~~ s:g/\<.+?\>//;
  	my $title = $node.elements(:TAG<title>);
  	$title ~~ s:g/\<.+?\>//;
  	my $desc = $node.elements(:TAG<description>);
  	$desc ~~ s:g/\<.+?\>//;
  	my $link = $node.elements(:TAG<link>);
  	$link ~~ s:g/\<.+?\>//;

	  say '### [' ~ $title ~ '](' ~ $link ~ ')';
	  say '';
	  say '**Category:** ' ~ $category;
	  say '';
	  say '' ~ decode-entities($desc);
	  say '';
	}
}


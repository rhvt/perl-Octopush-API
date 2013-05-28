=pod

=head1 NAME

Octopush::API - Octopush API implementation.

=head1 SYNOPSIS

use Octopush::API;

my $client = Octopush::API->new(
    user_login => 'john.doe@example.org',
    api_key    => 'XXXXXXXXXXXXXXXXXXXXXXXXXXXX',
);

$client->send_sms({
    sms_recipients => '+33606060606',
    sms_text       => 'Hello world',
    sms_type       => 'XXX'});

=head1 DESCRIPTION

    A Perl implementation of the Octopush API.
 
=cut

package Octopush::API;

use strict;
use warnings;

use version;
our $VERSION = qv('0.1');

use LWP::UserAgent;
use XML::Simple;

use constant {
    API_URL => 'http://www.octopush-dm.com/api/',    
};


=head1 METHODS

=head2 new(%args)

Object constructor for the Octopush::API class.

    my $client = Octopush::API->new(
        user_login => __USER_LOGIN__,
        api_key    => __API_KEY__,
    );

=cut

sub new {
    my ($class, %args) = @_;
    my $self = {};
    bless($self, $class);
    $self->{api_uri}    = API_URL;
    $self->{user_login} = $args{user_login};
    $self->{api_key}    = $args{api_key};
    $self->{ua}         = LWP::UserAgent->new(
                            agent => "Perl-Octopush-API/$VERSION" );
    return($self);
}


=head2 send_sms(%args)

Send an SMS to a recipient or a list of recipients.

    my $res = $client->send_sms({
        sms_recipients => '+33606060606',
        sms_text       => 'Hello world',
        sms_type       => 'XXX',
        request_mode   => 'simu'});

=cut

sub send_sms {
    my ($self, $args) = @_;
    return $self->_call('sms', $args);
}


=head2 get_balance(%args)

Get the balance of your account.

    my $res = $client->get_balance();

=cut

sub get_balance {
    my ($self, $args) = @_;
    return $self->_call('balance', $args);
}


=head2 get_deliveries(%args)

Get deliveries of a specific SMS.

    my $res = $client->get_deliveries('
        sms_ticket => __SMS_TICKET__});

=cut

sub get_deliveries {
    my ($self, $args) = @_;
    return $self->_call('deliveries', $args);
}


=head2 get_stops(%args)

Check if a recipient or a list of recipients have asked to stop SMS reception.

    my $res = $client->get_stops('
        sms_recipients => '+33606060606'});

=cut

sub get_stops {
    my ($self, $args) = @_;
    return $self->_call('stops', $args);
}


sub _call {
    my ($self, $method, $args) = @_;
    my $post_params = [ map { $_ => $args->{$_} } sort keys %{$args} ];
    push @{$post_params}, 'user_login' => $self->{user_login};
    push @{$post_params}, 'api_key'    => $self->{api_key};
    my $res = $self->{ua}->post(
        $self->{api_uri}.$method,
        'Content_type' => 'form-data',
        'Content'      => $post_params,
    )->content;
    return XMLin($res);
}


1;

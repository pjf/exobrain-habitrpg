package Exobrain::Agent::HabitRPG;
use Moose::Role;
use Method::Signatures;

with 'Exobrain::Agent';

# ABSTRACT: Roles for to HabitRPG agents
# VERSION

=head1 SYNOPSIS

    use Moose;
    with 'Exobrain::Agent::HabitRPG'

=head1 DESCRIPTION

This role provides useful methods and attributes for agents wishing
to integrate with the HabitRPG web service.

=cut

sub component_name { "HabitRPG" }

=method habitrpg

    my $tasks = $self->habitrpg->tasks;

Returns an authenticated, connected, L<WebService::HabitRPG> object.

=cut

has habitrpg => (
    isa => 'WebService::HabitRPG', is => 'ro', lazy => 1, builder => '_build_habit',
);

method _build_habit() {
    my $config = $self->config;

    my $api_token = $config->{api_token} or die "API token not found";
    my $user_id   = $config->{user_id}   or die "User ID not found";

    # Lazy load our module
    eval "use WebService::HabitRPG; 1;" or die $@;

    return WebService::HabitRPG->new(
        api_token => $api_token,
        user_id   => $user_id,
    );
}

1;

=for Pod::Coverage component_name

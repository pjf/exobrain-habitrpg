package Exobrain::HabitRPG;
use Moose;
use Exobrain::Config;
use feature qw(say);

# ABSTRACT: HabitRPG components for Exobrain
# VERSION

with 'Exobrain::Component';

sub component { "habitrpg" };

sub services {
    return (
        sink => 'HabitRPG::Sink',
    );
}

sub setup {

    # Load module and die swiftly on failure
    eval 'use WebService::HabitRPG; 1;' or die $@;

    say "Welcome to the Exobrain::HabitRPG setup process.";
    say "To complete setup, we'll need your HabitRPG API key and user ID";
    say "These can be found on your HabitRPG settings page.";

    print "API token: ";
    chomp( my $api = <STDIN> );

    print "User ID ";
    chomp( my $user = <STDIN> );

    # Check to see if we auth okay.

    my $habit = WebService::HabitRPG->new(
        api_token => $api,
        user_id   => $user,
    );
    
    # Make a call to ensure we auth

    $habit->user;

    say "\nThanks! Writing configuration...";

    my $config =
        "[Components]\n" .
        "HabitRPG=$VERSION\n\n" .

        "[HabitRPG]\n" .
        "api_token = $api\n" .
        "user_id   = $user\n"
    ;

    my $filename = Exobrain::Config->write_config('HabitRPG.ini', $config);

    say "\nConfig written to $filename. Have a nice day!";

    return;
}

1;

=for Pod::Coverage setup services component

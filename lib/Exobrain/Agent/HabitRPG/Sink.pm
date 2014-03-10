package Exobrain::Agent::HabitRPG::Sink;
use Method::Signatures;
use Moose;

with 'Exobrain::Agent::HabitRPG';
with 'Exobrain::Agent::Run';

# ABSTRACT: Send personal log events to iDoneThis
# VERSION

method run() {
    $self->exobrain->watch_loop(
        class => 'Intent::HabitRPG',
        then  => sub {
            my $event = shift;
            my $hrpg  = $self->habitrpg;

            my $task      = $event->task;
            my $direction = $event->direction;

            my $stats = $hrpg->user->{stats};

            my $result = $hrpg->updown($task, $direction);

            my $name = $hrpg->get_task($task)->{text};

            my $msg;

            if ($direction eq "up") {
                $msg = sprintf(
                    "Congrats! You gained %+.2f XP and %+.2f GP for completing: $name",
                    $result->{exp} - $stats->{exp},
                    $result->{gp}  - $stats->{gp},
                );
            }
            else {
                # Must be down
                $msg = sprintf(
                    "Oh no! You lost %+.2f HP for: $name",
                    $result->{hp} - $stats->{hp},
                )
            }

            $event->exobrain->notify($msg);
        }
    );
}

1;

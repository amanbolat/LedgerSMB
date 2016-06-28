package PageObject::Setup::EditUser;

use strict;
use warnings;

use Carp;
use Moose;
use PageObject;
extends 'PageObject';


sub _verify {
    my ($self) = @_;
    my $page = $self->stash->{ext_wsl}->page;

    $page->find('*labeled', text => $_)
        for ("Password",
             # mention some role names; we want to verify they're there
             "account all",
             "employees manage",
        );

    $page->find('*button', text => $_)
        for ("Reset Password", "Save Groups");

    return $self;
}


my %roles_checkbox_filter = (
    'all' => '',
    'checked' => "and \@checked='checked'",
    'unchecked' => "and \@checked=''"
    );

sub get_perms_checkboxes {
    my $self = shift @_;
    my $page = $self->stash->{ext_wsl}->page;
    my %params = @_;

    $params{filter} ||= 'all';
    my $filter = $roles_checkbox_filter{$params{filter}};

    my @checkboxes =
        $page->find("//table[\@id='user-roles']")
        ->find_all(".//input[\@type='checkbox' $filter]");

    return \@checkboxes;
}

sub is_checked_perms_checkbox {
    my ($self, $label) = @_;
    my $page = $self->stash->{ext_wsl}->page;
    my $box = $page->find('*labeled', text => $label);

    # assume the returned element is of type checkbox
    return ($box->get_attribute('checked') eq 'true');
}



__PACKAGE__->meta->make_immutable;

1;
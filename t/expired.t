use Test::More tests => 4;

use_ok('MojoX::Session');
use_ok('MojoX::Session::Store::DBI');
use_ok('MojoX::Session::Transport::Cookie');

use DBI;
use Mojo::Transaction;
use Mojo::Cookie::Request;

my $dbh = DBI->connect("dbi:SQLite:table.db") or die $DBI::errstr;
my $tx = Mojo::Transaction->new();

my $session = MojoX::Session->new(
    store     => MojoX::Session::Store::DBI->new(dbh       => $dbh),
    transport => MojoX::Session::Transport::Cookie->new(tx => $tx),
    expires   => 1
);

my $sid = $session->create();
$session->flush();

diag 'Sleep 2 seconds to expire session';
sleep(2);

my $cookie = Mojo::Cookie::Request->new(name => 'sid', value => $sid);
$tx->req->cookies($cookie);

ok(not defined $session->load());

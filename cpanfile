requires 'Class::Load';
requires 'Config::Tiny';
requires 'File::chdir';
requires 'JSON';
requires 'Module::CoreList';
requires 'Module::CPANfile';

on 'test' => sub {
    requires 'Test::More';
    requires 'Test::TempDir::Tiny';
};

requires 'perl', '5.008001';
requires 'Encode';
requires 'Test2', '>= 1.302133';
requires 'Test2::API';
requires 'URI::Escape';

on 'test' => sub {
    requires 'Test::More', '0.98';
};


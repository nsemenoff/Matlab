clear all

pset_file = 'parameter_sets.csv';
pset_id = 1;

[pkt, state] = simple_tx(pset_file, pset_id, 'stream_driver','wav',...
    'stream_driver_args','test_janus_5m.wav', ...
    'stream_fs',44100, ...
    'packet_app_data','0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1faa55aa5581817e7e0102030405060708090a0b0c0d0e0f');

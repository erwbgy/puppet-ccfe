require 'spec_helper'

describe 'ccfe', :type => 'class' do
  context 'no parameters' do
    let(:params) { {} }
    it {
      should create_class('ccfe::config').with( {
        'servers' => [ '0.pool.ccfe.org', '1.pool.ccfe.org', '2.pool.ccfe.org' ],
        'iburst'  => false,
      } )
    }
    it {
      should contain_file('/etc/ccfe.conf').with( {
        'ensure'  => 'present',
        'mode'    => '0444',
      } )
    }
    it 'server entries' do
      content = catalogue.resource('file', '/etc/ccfe.conf').send(:parameters)[:content]
      content.should match('^server 0.pool.ccfe.org$')
      content.should match('^server 1.pool.ccfe.org$')
      content.should match('^server 2.pool.ccfe.org$')
    end
  end
  context 'servers parameter' do
    let(:params) { { :servers => [ 'ccfe1.example.com', 'ccfe2.example.com' ] } }
    it {
      should create_class('ccfe::config').with( {
        'servers' => [ 'ccfe1.example.com', 'ccfe2.example.com' ],
        'iburst'  => false,
      } )
    }
    it {
      should contain_file('/etc/ccfe.conf').with( {
        'ensure'  => 'present',
        'mode'    => '0444',
      } )
    }
    it 'server entries' do
      content = catalogue.resource('file', '/etc/ccfe.conf').send(:parameters)[:content]
      content.should match('^server ccfe1.example.com$')
      content.should match('^server ccfe2.example.com$')
    end
  end
  context 'country parameter' do
    let(:params) { { :country => 'uk' } }
    it {
      should create_class('ccfe::config').with( {
        'servers' => [ '0.uk.pool.ccfe.org', '1.uk.pool.ccfe.org', '2.uk.pool.ccfe.org' ],
      } )
    }
    it {
      should contain_file('/etc/ccfe.conf').with( {
        'ensure'  => 'present',
        'mode'    => '0444',
      } )
    }
    it 'server entries' do
      content = catalogue.resource('file', '/etc/ccfe.conf').send(:parameters)[:content]
      content.should match('^server 0.uk.pool.ccfe.org$')
      content.should match('^server 1.uk.pool.ccfe.org$')
      content.should match('^server 2.uk.pool.ccfe.org$')
    end
  end
  context 'continent parameter' do
    let(:params) { { :continent => 'asia' } }
    it {
      should create_class('ccfe::config').with( {
        'servers' => [ '0.asia.pool.ccfe.org', '1.asia.pool.ccfe.org', '2.asia.pool.ccfe.org' ],
      } )
    }
    it {
      should contain_file('/etc/ccfe.conf').with( {
        'ensure'  => 'present',
        'mode'    => '0444',
      } )
    }
    it 'server entries' do
      content = catalogue.resource('file', '/etc/ccfe.conf').send(:parameters)[:content]
      content.should match('^server 0.asia.pool.ccfe.org$')
      content.should match('^server 1.asia.pool.ccfe.org$')
      content.should match('^server 2.asia.pool.ccfe.org$')
    end
  end
  context 'servers takes precendence over country and continent' do
    let(:params) { { :servers => [ 'ccfe1.example.com' ], :country => 'za', :continent => 'asia' } }
    it {
      should create_class('ccfe::config').with( {
        'servers' => [ 'ccfe1.example.com' ],
      } )
    }
    it {
      should contain_file('/etc/ccfe.conf').with( {
        'ensure'  => 'present',
        'mode'    => '0444',
      } )
    }
    it 'server entries' do
      content = catalogue.resource('file', '/etc/ccfe.conf').send(:parameters)[:content]
      content.should match('^server ccfe1.example.com$')
    end
  end
  context 'servers unset; country takes precendence over continent' do
    let(:params) { { :country => 'za', :continent => 'asia' } }
    it {
      should create_class('ccfe::config').with( {
        'servers' => [ '0.za.pool.ccfe.org', '1.za.pool.ccfe.org', '2.za.pool.ccfe.org' ],
      } )
    }
    it {
      should contain_file('/etc/ccfe.conf').with( {
        'ensure'  => 'present',
        'mode'    => '0444',
      } )
    }
    it 'server entries' do
      content = catalogue.resource('file', '/etc/ccfe.conf').send(:parameters)[:content]
      content.should match('^server 0.za.pool.ccfe.org$')
      content.should match('^server 1.za.pool.ccfe.org$')
      content.should match('^server 2.za.pool.ccfe.org$')
    end
  end
  context 'iburst parameter true' do
    let(:params) { { 
      :servers => [ 'ccfe1.example.com', 'ccfe2.example.com' ],
      :iburst  => true,
    } }
    it {
      should create_class('ccfe::config').with( {
        'servers' => [ 'ccfe1.example.com', 'ccfe2.example.com' ],
        'iburst'  => true,
      } )
    }
    it {
      should contain_file('/etc/ccfe.conf').with( {
        'ensure'  => 'present',
        'mode'    => '0444',
      } )
    }
    it 'server entries have an iburst parameter' do
      content = catalogue.resource('file', '/etc/ccfe.conf').send(:parameters)[:content]
      content.should match('^server ccfe1.example.com iburst$')
      content.should match('^server ccfe2.example.com iburst$')
    end
  end
end

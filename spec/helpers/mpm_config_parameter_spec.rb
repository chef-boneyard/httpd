require_relative '../../libraries/info_mpm_config_parameter'

describe 'default_value_for' do
  before do
    extend HttpdCookbook::Helpers
  end

  context 'when using apache 2.2' do
    context 'when using prefork' do
      it 'returns the correct value for :startservers' do
        expect(
          default_value_for('2.2', 'prefork', :startservers)
        ).to eq('5')
      end

      it 'returns the correct value for :minspareservers' do
        expect(
          default_value_for('2.2', 'prefork', :minspareservers)
        ).to eq('5')
      end

      it 'returns the correct value for :maxspareservers' do
        expect(
          default_value_for('2.2', 'prefork', :maxspareservers)
        ).to eq('10')
      end

      it 'returns the correct value for :maxclients' do
        expect(
          default_value_for('2.2', 'prefork', :maxclients)
        ).to eq('150')
      end

      it 'returns the correct value for :maxrequestsperchild' do
        expect(
          default_value_for('2.2', 'prefork', :maxrequestsperchild)
        ).to eq('0')
      end

      it 'returns the correct value for :minsparethreads' do
        expect(
          default_value_for('2.2', 'prefork', :minsparethreads)
        ).to eq(nil)
      end

      it 'returns the correct value for :maxsparethreads' do
        expect(
          default_value_for('2.2', 'prefork', :maxsparethreads)
        ).to eq(nil)
      end

      it 'returns the correct value for :threadlimit' do
        expect(
          default_value_for('2.2', 'prefork', :threadlimit)
        ).to eq(nil)
      end

      it 'returns the correct value for :threadsperchild' do
        expect(
          default_value_for('2.2', 'prefork', :threadsperchild)
        ).to eq(nil)
      end

      it 'returns the correct value for :maxrequestworkers' do
        expect(
          default_value_for('2.2', 'prefork', :maxrequestworkers)
        ).to eq(nil)
      end

      it 'returns the correct value for :maxconnectionsperchild' do
        expect(
          default_value_for('2.2', 'prefork', :maxconnectionsperchild)
        ).to eq(nil)
      end
    end

    context 'when using worker' do
      it 'returns the correct value for :startservers' do
        expect(
          default_value_for('2.2', 'worker', :startservers)
        ).to eq('2')
      end

      it 'returns the correct value for :minspareservers' do
        expect(
          default_value_for('2.2', 'worker', :minspareservers)
        ).to eq(nil)
      end

      it 'returns the correct value for :maxspareservers' do
        expect(
          default_value_for('2.2', 'worker', :maxspareservers)
        ).to eq(nil)
      end

      it 'returns the correct value for :maxclients' do
        expect(
          default_value_for('2.2', 'worker', :maxclients)
        ).to eq('150')
      end

      it 'returns the correct value for :maxrequestsperchild' do
        expect(
          default_value_for('2.2', 'worker', :maxrequestsperchild)
        ).to eq('0')
      end

      it 'returns the correct value for :minsparethreads' do
        expect(
          default_value_for('2.2', 'worker', :minsparethreads)
        ).to eq('25')
      end

      it 'returns the correct value for :maxsparethreads' do
        expect(
          default_value_for('2.2', 'worker', :maxsparethreads)
        ).to eq('75')
      end

      it 'returns the correct value for :threadlimit' do
        expect(
          default_value_for('2.2', 'worker', :threadlimit)
        ).to eq('64')
      end

      it 'returns the correct value for :threadsperchild' do
        expect(
          default_value_for('2.2', 'worker', :threadsperchild)
        ).to eq('25')
      end

      it 'returns the correct value for :maxrequestworkers' do
        expect(
          default_value_for('2.2', 'worker', :maxrequestworkers)
        ).to eq(nil)
      end

      it 'returns the correct value for :maxconnectionsperchild' do
        expect(
          default_value_for('2.2', 'worker', :maxconnectionsperchild)
        ).to eq(nil)
      end
    end

    context 'when using event' do
      it 'returns the correct value for :startservers' do
        expect(
          default_value_for('2.2', 'event', :startservers)
        ).to eq('2')
      end

      it 'returns the correct value for :minspareservers' do
        expect(
          default_value_for('2.2', 'event', :minspareservers)
        ).to eq(nil)
      end

      it 'returns the correct value for :maxspareservers' do
        expect(
          default_value_for('2.2', 'event', :maxspareservers)
        ).to eq(nil)
      end

      it 'returns the correct value for :maxclients' do
        expect(
          default_value_for('2.2', 'event', :maxclients)
        ).to eq('150')
      end

      it 'returns the correct value for :maxrequestsperchild' do
        expect(
          default_value_for('2.2', 'event', :maxrequestsperchild)
        ).to eq('0')
      end

      it 'returns the correct value for :minsparethreads' do
        expect(
          default_value_for('2.2', 'event', :minsparethreads)
        ).to eq('25')
      end

      it 'returns the correct value for :maxsparethreads' do
        expect(
          default_value_for('2.2', 'event', :maxsparethreads)
        ).to eq('75')
      end

      it 'returns the correct value for :threadlimit' do
        expect(
          default_value_for('2.2', 'event', :threadlimit)
        ).to eq('64')
      end

      it 'returns the correct value for :threadsperchild' do
        expect(
          default_value_for('2.2', 'event', :threadsperchild)
        ).to eq('25')
      end

      it 'returns the correct value for :maxrequestworkers' do
        expect(
          default_value_for('2.2', 'event', :maxrequestworkers)
        ).to eq(nil)
      end

      it 'returns the correct value for :maxconnectionsperchild' do
        expect(
          default_value_for('2.2', 'event', :maxconnectionsperchild)
        ).to eq(nil)
      end
    end
  end

  context 'when using apache 2.4' do
    context 'when using prefork' do
      it 'returns the correct value for :startservers' do
        expect(
          default_value_for('2.4', 'prefork', :startservers)
        ).to eq('5')
      end

      it 'returns the correct value for :minspareservers' do
        expect(
          default_value_for('2.4', 'prefork', :minspareservers)
        ).to eq('5')
      end

      it 'returns the correct value for :maxspareservers' do
        expect(
          default_value_for('2.4', 'prefork', :maxspareservers)
        ).to eq('10')
      end

      it 'returns the correct value for :maxclients' do
        expect(
          default_value_for('2.4', 'prefork', :maxclients)
        ).to eq(nil)
      end

      it 'returns the correct value for :maxrequestsperchild' do
        expect(
          default_value_for('2.4', 'prefork', :maxrequestsperchild)
        ).to eq(nil)
      end

      it 'returns the correct value for :minsparethreads' do
        expect(
          default_value_for('2.4', 'prefork', :minsparethreads)
        ).to eq(nil)
      end

      it 'returns the correct value for :maxsparethreads' do
        expect(
          default_value_for('2.4', 'prefork', :maxsparethreads)
        ).to eq(nil)
      end

      it 'returns the correct value for :threadlimit' do
        expect(
          default_value_for('2.4', 'prefork', :threadlimit)
        ).to eq(nil)
      end

      it 'returns the correct value for :threadsperchild' do
        expect(
          default_value_for('2.4', 'prefork', :threadsperchild)
        ).to eq(nil)
      end

      it 'returns the correct value for :maxrequestworkers' do
        expect(
          default_value_for('2.4', 'prefork', :maxrequestworkers)
        ).to eq('150')
      end

      it 'returns the correct value for :maxconnectionsperchild' do
        expect(
          default_value_for('2.4', 'prefork', :maxconnectionsperchild)
        ).to eq('0')
      end
    end

    context 'when using worker' do
      it 'returns the correct value for :startservers' do
        expect(
          default_value_for('2.4', 'worker', :startservers)
        ).to eq('2')
      end

      it 'returns the correct value for :minspareservers' do
        expect(
          default_value_for('2.4', 'worker', :minspareservers)
        ).to eq(nil)
      end

      it 'returns the correct value for :maxspareservers' do
        expect(
          default_value_for('2.4', 'worker', :maxspareservers)
        ).to eq(nil)
      end

      it 'returns the correct value for :maxclients' do
        expect(
          default_value_for('2.4', 'worker', :maxclients)
        ).to eq(nil)
      end

      it 'returns the correct value for :maxrequestsperchild' do
        expect(
          default_value_for('2.4', 'worker', :maxrequestsperchild)
        ).to eq(nil)
      end

      it 'returns the correct value for :minsparethreads' do
        expect(
          default_value_for('2.4', 'worker', :minsparethreads)
        ).to eq('25')
      end

      it 'returns the correct value for :maxsparethreads' do
        expect(
          default_value_for('2.4', 'worker', :maxsparethreads)
        ).to eq('75')
      end

      it 'returns the correct value for :threadlimit' do
        expect(
          default_value_for('2.4', 'worker', :threadlimit)
        ).to eq('64')
      end

      it 'returns the correct value for :threadsperchild' do
        expect(
          default_value_for('2.4', 'worker', :threadsperchild)
        ).to eq('25')
      end

      it 'returns the correct value for :maxrequestworkers' do
        expect(
          default_value_for('2.4', 'worker', :maxrequestworkers)
        ).to eq('150')
      end

      it 'returns the correct value for :maxconnectionsperchild' do
        expect(
          default_value_for('2.4', 'worker', :maxconnectionsperchild)
        ).to eq('0')
      end
    end

    context 'when using event' do
      it 'returns the correct value for :startservers' do
        expect(
          default_value_for('2.4', 'event', :startservers)
        ).to eq('2')
      end

      it 'returns the correct value for :minspareservers' do
        expect(
          default_value_for('2.4', 'event', :minspareservers)
        ).to eq(nil)
      end

      it 'returns the correct value for :maxspareservers' do
        expect(
          default_value_for('2.4', 'event', :maxspareservers)
        ).to eq(nil)
      end

      it 'returns the correct value for :maxclients' do
        expect(
          default_value_for('2.4', 'event', :maxclients)
        ).to eq(nil)
      end

      it 'returns the correct value for :maxrequestsperchild' do
        expect(
          default_value_for('2.4', 'event', :maxrequestsperchild)
        ).to eq(nil)
      end

      it 'returns the correct value for :minsparethreads' do
        expect(
          default_value_for('2.4', 'event', :minsparethreads)
        ).to eq('25')
      end

      it 'returns the correct value for :maxsparethreads' do
        expect(
          default_value_for('2.4', 'event', :maxsparethreads)
        ).to eq('75')
      end

      it 'returns the correct value for :threadlimit' do
        expect(
          default_value_for('2.4', 'event', :threadlimit)
        ).to eq('64')
      end

      it 'returns the correct value for :threadsperchild' do
        expect(
          default_value_for('2.4', 'event', :threadsperchild)
        ).to eq('25')
      end

      it 'returns the correct value for :maxrequestworkers' do
        expect(
          default_value_for('2.4', 'event', :maxrequestworkers)
        ).to eq('150')
      end

      it 'returns the correct value for :maxconnectionsperchild' do
        expect(
          default_value_for('2.4', 'event', :maxconnectionsperchild)
        ).to eq('0')
      end
    end
  end
end

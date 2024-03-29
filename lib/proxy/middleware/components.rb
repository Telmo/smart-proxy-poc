module SmartProxy
  module Middleware
    class Component
      attr_reader :entries

      def initialize
        @entries = []
        yield self if block_given?
      end

      def remove(klass)
        entries.delete_if { |entry| entry.klass == klass }
      end

      def add(klass, *args)
        entries << Entry.new(klass, *args) unless exists?(klass)
      end

      def insert_before(oldklass, newklass, *args)
        i = entries.index { |entry| entry.klass == newklass }
        new_entry = i.nil? ? Entry.new(newklass, *args) : entries.delete_at(i)
        i = entries.find_index { |entry| entry.klass == oldklass } || 0
        entries.insert(i, new_entry)
      end

      def insert_after(oldklass, newklass, *args)
        i = entries.index { |entry| entry.klass == newklass }
        new_entry = i.nil? ? Entry.new(newklass, *args) : entries.delete_at(i)
        i = entries.find_index { |entry| entry.klass == oldklass } || entries.count - 1
        entries.insert(i+1, new_entry)
      end

      def exists?(klass)
        entries.any? { |entry| entry.klass == klass }
      end

      def retrieve
        entries.map(&:make_new)
      end

      def clear
        entries.clear
      end

      def invoke(*args, &final_action)
        chain = retrieve.dup
        traverse_chain = lambda do
          if chain.empty?
            final_action.call
          else
            chain.shift.call(*args, &traverse_chain)
          end
        end
        traverse_chain.call
      end
    end

    class Entry
      attr_reader :klass
      def initialize(klass, *args)
        @klass = klass
        @args  = args
      end

      def make_new
        @klass.new(*@args)
      end
    end
  end
end

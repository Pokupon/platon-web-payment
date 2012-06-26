module PHP

# string = PHP.serialize(mixed var[, bool assoc])
#
# Returns a string representing the argument in a form PHP.unserialize
# and PHP's unserialize() should both be able to load.
#
# Array, Hash, Fixnum, Float, True/FalseClass, NilClass, String and Struct
# are supported; as are objects which support the to_assoc method, which
# returns an array of the form [['attr_name', 'value']..].  Anything else
# will raise a TypeError.
#
# If 'assoc' is specified, Array's who's first element is a two value
# array will be assumed to be an associative array, and will be serialized
# as a PHP associative array rather than a multidimensional array.
  def PHP.serialize(var, assoc = false) # {{{
    s = ''
    case var
      when Array
        s << "a:#{var.size}:{"
        if assoc and var.first.is_a?(Array) and var.first.size == 2
          var.each { |k, v|
            s << PHP.serialize(k, assoc) << PHP.serialize(v, assoc)
          }
        else
          var.each_with_index { |v, i|
            s << "i:#{i};#{PHP.serialize(v, assoc)}"
          }
        end

        s << '}'

      when Hash
        s << "a:#{var.size}:{"
        var.each do |k, v|
          s << "#{PHP.serialize(k, assoc)}#{PHP.serialize(v, assoc)}"
        end
        s << '}'

      when Struct
        # encode as Object with same name
        s << "O:#{var.class.to_s.length}:\"#{var.class.to_s.downcase}\":#{var.members.length}:{"
        var.members.each do |member|
          s << "#{PHP.serialize(member, assoc)}#{PHP.serialize(var[member], assoc)}"
        end
        s << '}'

      when String, Symbol
        s << "s:#{var.to_s.bytesize}:\"#{var.to_s}\";"

      when Fixnum # PHP doesn't have bignums
        s << "i:#{var};"

      when Float
        s << "d:#{var};"

      when NilClass
        s << 'N;'

      when FalseClass, TrueClass
        s << "b:#{var ? 1 : 0};"

      else
        if var.respond_to?(:to_assoc)
          v = var.to_assoc
          # encode as Object with same name
          s << "O:#{var.class.to_s.length}:\"#{var.class.to_s.downcase}\":#{v.length}:{"
          v.each do |k, v|
            s << "#{PHP.serialize(k.to_s, assoc)}#{PHP.serialize(v, assoc)}"
          end
          s << '}'
        else
          raise TypeError, "Unable to serialize type #{var.class}"
        end
    end

    s
  end # }}}
end


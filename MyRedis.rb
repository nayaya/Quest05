class MyRedis

    def initialize
        @my_hash = Hash.new
    end

    def my_set key, value
        @my_hash[key] = value
    end

    def my_rename key, new_key
        @my_hash.clone.each_key do |k|
            if @my_hash.has_key?(key) && !@my_hash.has_key?(new_key)
                @my_hash[new_key] = @my_hash.delete key 
                return true
            else
                return false
            end
        end
    end

    def my_get key
        @my_hash.has_key?(key) && @my_hash[key] 
    end

    def my_mset *args
        if !args.empty?
            args.each do |pair|
                pair.each do |item|
                    my_set item[0], item[1]
                end
            end
        else
            puts "Unable to read args"
        end
    end

    def my_mget keys
        values = [] 
        keys.each do |i|
            @my_hash.has_key?(i) ? values << @my_hash[i] : values = []
        end
        values.inspect
    end

    def my_del keys
        !keys.empty? && keys.each do |i|
            @my_hash.has_key?(i) && @my_hash.delete(i)
        end
    end

    def my_exists key 
        @my_hash.has_key?(key) ? true : false
    end

    def my_show 
        @my_hash
    end

    def backup
        File.open("my_dump.rdb", "w") {|f| f.write(my_show.inspect) }
    end

    def restore
        File.open("my_dump.rdb", "r") {|f| @my_hash = eval(f.read)}
    end

end

myRedis = MyRedis.new
myRedis.my_mset([['a', 3], ['b', 8], [3, 'i']])
myRedis.my_set('c', 45)
myRedis.backup
puts myRedis.my_show
puts myRedis.my_del(['c'])
puts myRedis.my_show
puts myRedis.my_rename('b', 'w')
puts myRedis.my_show
myRedis.restore
puts myRedis.my_show
puts myRedis.my_get 'a'


import arguable.ArgParser;

using StringTools;

class HaxelibCounter {

        //The main entry point
    static function main() {

        var args = ArgParser.parse( Sys.args() );

        print('haxelibcounter');

        debug('> found args $args');

        if(args.length == 0) {
            return usage();
        }

        if(args.has('count')) {
            return do_count(args);
        }

    } //main

    static function usage() {
        print('usage:');
        print('   --count | displays the number of haxelib libraries installed');
        print('   --show-names | must be specified with --count, lists installed haxelibs one per line');
    }

    static function do_count(args) {

            //call `haxelib list` and read the output:
        var process = new sys.io.Process('haxelib',['list']);
        var result = process.stdout.readAll().toString();

        debug('> haxelib list returned a ${result.length} length string');

        if(result.length > 0) {

                //split the list up by each line
            var items = result.split('\n');

                //remove any blank items from the list, in case haxelib adds empty lines
            items = items.filter(function(item) return item.length > 0);

                //we know how many there are now
            print('${items.length} haxelibs installed!');

                //now we can handle the additional flag
            if(args.has('show-names')) {

                var item_names = items.map(function(item) return item.split(': ')[0]);
                for(name in item_names) print('  $name');

            }

        } else {
            print('An unknown error occured. `haxelib list` was not able to be called, it returned status ${process.exitCode()}');
        }

    } //do_count

//Internal

    static function print(value) {
        #if debug trace(value);
        #else Sys.println(value);
        #end
    }

    static function debug(value) {
        #if haxelibcounter_verbose
            trace(value);
        #end
    }

} //HaxelibCount
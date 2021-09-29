import org.apache.hadoop.fs.permission.FsPermission
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.conf.Configuration;

val loc = "/tmp/hwc/"+sc.sparkUser

def createTmpDir(): Unit={
    val conf = new Configuration()
val fs= FileSystem.get(conf)
val Permission = new FsPermission("700")

fs.mkdirs(new Path(loc),Permission)
}

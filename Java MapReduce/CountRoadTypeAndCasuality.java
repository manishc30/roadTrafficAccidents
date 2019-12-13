
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Counter;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.Reducer.Context;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;



public class CountRoadTypeAndCasuality extends Configured implements Tool {

	public static class CountRoadTypeAndCasualityMapper extends
			Mapper<LongWritable, Text, IntWritable, IntWritable> {
		public static final String ROAD_COUNTER_GROUP = "State";
		public static final String UNKNOWN_COUNTER = "Unknown";
		public static final String NULL_OR_EMPTY_COUNTER = "Null or Empty";
		private String[] roadArray = new String[] { "6", "7", "9", "3",
				"2", "1"};
		private HashSet<String> roads = new HashSet<String>(
				Arrays.asList(roadArray));
		
		
		public void map(LongWritable key, Text value, Context context)
				throws IOException, InterruptedException {

			
	            if (key.get() == 0 && value.toString().contains("Accident_Index") /*Some condition satisfying it is header*/)
	                return;
	            else {
			String[] field = value.toString().split(",");

		
			//System.out.println("Location manish is: " + field);
			if (null != field && field[8].length() >0 && field[16].length() >0) {
				//System.out.println("No of Casualty: " + field[8] + " Road type: " + field[16]);
				
				String[] tokens = field[3].toUpperCase().split("\\s");
				int casulty = Integer.parseInt(field[8]);
				
				boolean unknown = true;
				
					int cau = 0;
					if (roads.contains(field[16])) {
					
						cau = cau + casulty;
						
						context.getCounter(ROAD_COUNTER_GROUP, field[16])
								.increment(1);
						unknown = false;
						
					}
				
				
				if (unknown) {
					context.getCounter(ROAD_COUNTER_GROUP, UNKNOWN_COUNTER)
							.increment(1);
				}
			} else {
				
				
				context.getCounter(ROAD_COUNTER_GROUP, NULL_OR_EMPTY_COUNTER)
						.increment(1);
			}
			
			
		}
	          //  context.write(context.getCounter(arg0), arg1);
			}
	}
	
	
	

	public static void main(String[] args) throws Exception {
		int res = ToolRunner.run(new Configuration(),
				new CountRoadTypeAndCasuality(), args);
		System.exit(res);
	}

	@SuppressWarnings("deprecation")
	@Override
	public int run(String[] args) throws Exception {
		Configuration conf = new Configuration();
		String[] otherArgs = new GenericOptionsParser(conf, args)
				.getRemainingArgs();
		if (otherArgs.length != 2) {
			System.err.println("Usage: NumberOfUsersByState <in> <out>");
			ToolRunner.printGenericCommandUsage(System.err);
			System.exit(2);
		}

		Job job = new Job(conf, "CountRoadTypeAndCasuality");
		job.setJarByClass(CountRoadTypeAndCasuality.class);
		job.setMapperClass(CountRoadTypeAndCasualityMapper.class);
		job.setOutputKeyClass(Text.class);
		
		job.setOutputValueClass(Text.class);
		FileInputFormat.addInputPath(job, new Path(otherArgs[0]));
		Path outputDir = new Path(otherArgs[1]);
		FileOutputFormat.setOutputPath(job, outputDir);
		boolean success = job.waitForCompletion(true);

		if (success) {
			String displayName = null;
			System.out.println("Job name: " + job.getJobName());
			for (Counter counter : job.getCounters().getGroup(
					CountRoadTypeAndCasualityMapper.ROAD_COUNTER_GROUP)) {
				if(counter.getDisplayName() == "1") {
					 displayName = "Roundabout";
				}
				else if(counter.getDisplayName() == "2") {
					displayName = "One way street";
				}
				else if(counter.getDisplayName() == "3") {
					displayName = "Dual carriageway";
				}
				else if(counter.getDisplayName() == "6") {
					displayName = "Single carriageway";
				}
				else if(counter.getDisplayName() == "7") {
					displayName = "Slip road";
				}
				else if(counter.getDisplayName() == "9") {
					displayName = "Road Type 9";
				}
				
				System.out.println(displayName + "\t"
						+ counter.getValue());
			}
		}
		
		//FileSystem.get(conf).delete(outputDir);

		return success ? 0 : 1;
	}
}

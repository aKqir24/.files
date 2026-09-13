# Create a cgroup
sudo cgcreate -g memory:/memlimit

# Set a memory limit (e.g. 500MB)
echo $((500 * 1024 * 1024)) | sudo tee /sys/fs/cgroup/memory/memlimit/memory.limit_in_bytes

# Run your program under this group
cgexec -g memory:memlimit ./your_leaky_program


#!/bin/bash

# This will avoid the execution and the check for the user root
export TEST=1

# Some common cli options
base_cmd="bin/lxc-build-project -n superproject -u aentos -c cookbooks.yml --"
output_base="lxc-create -n superproject -t ubuntu"


# Extra options (to be passed to the lxc-create) base case
testNoOpt()
{
  output=$($base_cmd -f foo)
  expected_output="$output_base -- -f foo"
  assertEquals "Wrong output" "$expected_output" "$output"
}


# Test Filesystem options
testNone()
{
  output=$($base_cmd -B none)
  expected_output="$output_base -B none --"
  assertEquals "Wrong output" "$expected_output" "$output"
}

testNonePlusExtraArgs()
{
  output=$($base_cmd -B none -f foo)
  expected_output="$output_base -B none -- -f foo"
  assertEquals "Wrong output" "$expected_output" "$output"
}

testNonePlusLeftArgs()
{
  output=$($base_cmd -f foo -B none)
  expected_output="$output_base -B none -- -f foo"
  assertEquals "Wrong output" "$expected_output" "$output"
}

testWrongOpt()
{
  output=$($base_cmd -B itdoesntexist)
  expected_output="$output_base -B itdoesntexist --"
  assertEquals "Wrong output" "$expected_output" "$output"
}

testTwoFlags()
{
  output=$($base_cmd -B -F)
  expected_output="$output_base -- -F"
  assertEquals "Wrong output" "$expected_output" "$output"
}

testFlagPlusOpts()
{
  output=$($base_cmd -B --release precise)
  expected_output="$output_base -- --release precise"
  assertEquals "Wrong output" "$expected_output" "$output"
}

# Dir special case
testDirWithArg()
{
  output=$($base_cmd -B dir --dir mydir)
  expected_output="$output_base -B dir --dir mydir --"
  assertEquals "Wrong output" "$expected_output" "$output"
}

testDirWithFlagNoArg()
{
  output=$($base_cmd -B dir --dir)
  assertFalse $?
}

testDirWithNoFlagNoArg()
{
  output=$($base_cmd -B dir)
  assertFalse $?
}

# LVM special case
testLvmNoOpts()
{
  output=$($base_cmd -B lvm)
  expected_output="$output_base -B lvm --"
  assertEquals "Wrong output" "$expected_output" "$output"
}

testLvmNoOptsExtraArg()
{
  output=$($base_cmd -B lvm -r precise)
  expected_output="$output_base -B lvm -- -r precise"
  assertEquals "Wrong output" "$expected_output" "$output"
}

testLvmOneOpt()
{
  output=$($base_cmd -B lvm --lvname lvname)
  expected_output="$output_base -B lvm --lvname lvname --"
  assertEquals "Wrong output" "$expected_output" "$output"
}

testLvmOneOptNoArg()
{
  output=$($base_cmd -B lvm --lvname)
  assertFalse "It didn't fail properly" $?
}

testLvmOneOptExtraArg()
{
  output=$($base_cmd -B lvm --lvname lvname -r precise)
  expected_output="$output_base -B lvm --lvname lvname -- -r precise"
  assertEquals "Wrong output" "$expected_output" "$output"
}

testLvmOneOptNoArgExtraArg()
{
  output=$($base_cmd -B lvm --lvname -r precise)
  assertFalse "It didn't fail properly" $?
}

testLvmAllOpts()
{
  output=$($base_cmd -B lvm --lvname lvname --vgname vgname --fstype fstype --fssize fssize)
  expected_output="$output_base -B lvm --lvname lvname --vgname vgname --fstype fstype --fssize fssize --"
  assertEquals "Wrong output" "$expected_output" "$output"
}

# load shunit2
. shunit2

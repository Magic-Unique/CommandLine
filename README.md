# CommandLine

> 0.0.5

A command line arguments parser of Objective-C

## Demo

See [Magic-Unique/MobileProvisionTool](https://github.com/Magic-Unique/MobileProvisionTool)

## Features

1. Support subcommands
2. Support Queries
	* key-value (require)
	* key-value (optional)
	* key-value (optional & default-if-nil)
	* key-values (as array, for multi-queries)
3. Support Flags
4. Support Abbr and multi-abbrs parsing
4. Auto create colorful help infomation (just like cocoapods.)
5. Auto print helping infomation if arguments is invalid
6. Version command
7. Output with verbose/success/warning/error/info
8. Custom colorful text

## Installation

### CocoaPods

```
pod 'CommandLine'
```

### Source

Drag ***CommandLine*** folder to your project.

### Import

```objc
#import "CommandLine.h"
```

## Usage

### Subcommand

If you want to define the command like:

```shell
$ pod spec create
```

it's meaning:

binary|command|subcommand|subsubcommand...
------|-------|----------|---
 pod  |  spec |  create  | ...

you can execute the code before parse.

```objc
CLCommand *pod = [CLCommand main];
CLCommand *spec = [pod defineSubcommand:@"spec"];
spec.explain = @"Spec commands"
{
	CLCommand *create = [spec defineSubcommand:@"create"];
    create.explain = @"Create a pod spec";
	[create onHandlerRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
		// do something to create a cocoapods spec.
                                     
		// return an error or an userInfo for succeed.
        return [CLResponse succeed:nil];
    }];
}
```
### Queries

If you want to define the command like:

```shell
$ codesign [--entitlement /path/to/entitlement.plist] --cert "iPhone Developer: XXXX" ...
# or
$ codesign [-e /path/to/entitlement.plist] -c "iPhone Developer: XXXX" ...
```

It's meaning:

|  Binary  |       Query Key 1        |       Query Value 1        |   Query Key 2    | Query Value 2 |
| :------: | :----------------------: | :------------------------: | :--------------: | :-----------: |
| codesign | entitlement/e (optional) | /path/to/entitlement.plist | cert/c (require) |   Cert Name   |

you can execute the code before parse.

```objective-c
CLCommand *codesign = [CLCommand main]; // get main command (without any command or subcommands)
codesign.setQuery(@"entitlement")
    .setAbbr('e')
    .optional()
    .setExplain("Entitlement.plist file path."); // define a optional query
codesign.setQuery(@"cert")
    .setAbbr('c')
    .require()
    .setExplain("Cert name"); // define a require query
[codesign onHandlerRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
    NSString *cert = request.queries[@"cert"]; // get value with key.
    NSString *entitlement = request.queries[@"entitlement"]; // nonable
	//	to code sign
    
    return [CLResponse succeed:nil];
}];
```

If you want to get a array value like:

```shell
$ demo --input /path/to/input1 --input /path/to/input2
```

It's meaning:

| Binary | Query Key | Query Value |
| --- | --- | --- |
| demo | input | path array |

you can execute the code before parse.

```objc

CLCommand *demo = [CLCommand main];
demo.setQuery(@"input").mutiable().require();
[demo onHandlerRequest: ^CLResponse *(CLCommand *command, CLRequest *request) {
	NSArray *inputs = request.queries[@"input"];
	
	return [CLResponse succeed:nil];
}];
```

### Flags

If you want to define the command like:

```shell
$ ls --all
# or
$ ls -a
```

It's meaning:

| Binary | Flag Key |
| ------ | -------- |
| ls     | all / a  |

you can execute the code before parse.

```objective-c
CLCommand *ls = [CLCommand main]; // get main command (without any command or subcommands)
ls.setFlag(@"all")
    .setAbbr('a')
    .setExplain(@"Print all contents."); // define a optional query
[ls onHandlerRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
    BOOL all = [request.flags containsObject:@"all"];
    
    // list and print
    NSFileManager *fmgr = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *contents = [fmgr contentsOfDirectory:[CLIOPath currentDirectory] error:&error];
    if (error) {
        printf("%s\n", error.localizedDescription.UTF8String);
        return [CLResponse error:error];
    }
    if (NO == all) {
    	NSMutableArray *mContents = [NSMutableArray arrayWithArray:contents];
        //	remove all item with "." prefix in mContents;
        contents = ;mContents copy];
    }
    for (NSString *item in contents) {
        printf("%s\n", item.UTF8String);
    }
    return [CLResponse success:nil];
}];
```

### Abbr & Multi-abbrs

For example:

```shell
# Multi-abbrs for flags:

$ rm -rf /path/to/directory

# is meaning:

$ rm -r -f /path/to/directory
$ rm --recursive --force /path/to/directory

# 'r' is recursive(flag)'s abbr, 'f' is force(flag)'s abbr.
```

```shell
# Multi-abbrs for flags and a query

$ codesign -fs 'iPhone Developer: XXXX (XXXX)' /path/to/Application.app

# is meaning:

$ codesign -f -s 'iPhone Developer: XXXX (XXXX)' /path/to/Application.app

# 'f' is replacing-exist-sign(flag)'s abbr
# 's' is signature(query)'s abbr 
```

**CommandLine is supporting parse multi-abbrs!**

### IOPaths

IOPaths is a type of value without any key. It's usually used in input, output path. Such as:

```shel
$ cd /change/to/directory/		# inpuut
$ mkdir /create/new/folder		# input
$ zip /to/.zip /source/folder	# output & input
```

you can execute the code before parse.

```objc
CLCommand *zip = [CLCommand main]; // get main command (without any command or subcommands)

/*
	User must type in an output path and one or more input path(s)
*/
zip.addRequirePath(@"output")
    .setExplain(@"output key");
zip.addRequirePath(@"input1")
    .setExplain(@"Input path");
zip.addOptionalPath(@"input2")
    .setExplain(@"Input path");

[zip onHandlerRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
    NSArray *paths = request.paths; // paths.count >= 2
    NSString *output = paths.firstObject;
    NSArray *inputs = ({
        NSMutableArray *inputs = paths.mutableCopy;
        [input removeObjectAtIndex:0];
        inputs.copy;
    });
    
    NSString *fullOutput = [CLIOPath abslutePath:output]; // replace `~` with $HOME and append current directory if needs.
    //	to zip
	return [CLResponse success:nil];
}];
```

### Parse

After you defined all commands and their subcommands, you can parse arguments.

**1. Make a request**

```objc
//	Making with arguments of main()
CLRequest *request = [CLRequest requestWithArgc:argc argv:argv];

//	Making with NSProcressInfo.processInfo.arguments
CLRequest *request = [CLRequest request];

//	See more in CLRequest.h ...
```

**2. Parse request**

```objc
CLResponse *response = [CLCommand handleRequest:request];
```

**3. Return in main()**

```objc
if (response.error) {
    return response.error.code;
} else {
    return 0;
}
```



### Helping Infomations

When should the tool print helping infomation ?

1. User type in `--help` or `-h` for helping
2. User type in illegal arguments. Such as: inputed 2 paths but 3 required, didnot input required query...

**CommandLine** will auto create a colorfull helping infomation and print automatically.

**Colorfull helping infomation ?** Yes ! Just like *CocoaPods*.

![CocoaPods Helping Infomations](Resources/help.png)

### Special output

#### 1. Verbose
Print more infomations mode.

It will be triggered by flag `--verbose`. 

You can use in task:

```objective-c
[request verbose:@"Making temp directory: %@", tempDirectory];
//	it will be print if the request contains `verbose` flag.
//	auto append a '\n' in end.
```
#### 2. Success

Print **green** text.

You can use in task:

```objc
[request success:@"Done! There are %lu devices in the mobileprovision", devices.count];// devices is instance of NSArray
//	print the text render with green color
//	auto append a '\n' in end.
```

#### 3. Warning

Pring **yellow** text.

```objc
[request warning:@"The directory is not exist, it will be ignore."];
//	print the text render with yellow color
//	auto append a '\n' in end.
```

#### 4. Error 
Print **red** text.

You can use in task:

```objc
[request error:@"Error: %@", error];// error is instance of NSError
//	print the text render with red color
//	auto append a '\n' in end.
```

#### 5. More Info

Print **light** text.

You can use in task:

```objc
[request info:@"XXXXXX"];
//	print the text with light font.
//	auto append a '\n' in end.
```

### Version

Print version of this tool.

```objc
[CLCommand setVersion:@"1.0.0"]; // do once.
```

```shell
$ tool --version
1.0.0

# or

$ tool -v
1.0.0
```

### Terminal

```objc
NSString *fileList = CLLaunch(nil, @"ls", @"-a", nil);
CLLaunch(@"~", @"zip", @"-qry", @"output.zip", @".", nil);
CLLaunch(nil, @[@"ls", @"-a"], nil);
```

### Print colorful text

```objc
#import "CCText.h"
CCPrintf(CCStyleBord|CCStyleItalic, @"A text with %@ and %@", @"bord", @"italic");
// see move CCStyle in CCText.h
```

## LICENCE

MIT.
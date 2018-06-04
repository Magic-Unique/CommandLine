# CommandLine

> 0.0.1

A command line arguments parser of Objective-C

## Features

[x] Support subcommands

[x] Support Queries

* key-value (require)

* key-value (optional)

* key-value (optional & default-if-nil)

[x] Support Flags

[x] Auto create colorful help infomation (just like cocoapods.)

[x] Auto print help infomation if arguments is invalid

[x] Version command

[x] Verbose

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
CLCommand * spec = [CLCommand defineCommand:@"spec"
                                    explain:@"Spec commands"
                                   onCreate:^(CLCommand *command) {
                                   //	Add extends query/flags to `command`
                                   } onRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
                                   //	The block will be called if user did not type `create` or any subcommand.
                                   //	You can replace the block with `nil` if you do not want to do anything. If you do it, you must to define one or more subcommands, and user must type in a subcommand to execute one of subcommands.
                                   }];
CLCommand *create = [spec defineSubcommand:@"create"
								   explain:@"Create a pod spec"
                                  onCreate:nil
                                 onRequest:^CLResponse *(CLCommand *command, CLRequest *request) {
	// do something to create a cocoapods spec.
                                     
	// return an error or an userInfo for succeed.
	return [CLResponse succeed:nil];
}];
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
CLCommand *codesign = [CLCommand sharedCommand]; // get main command (without any command or subcommands)
codesign.setQuery(@"entitlement").setAbbr('e').optional().setExplain("Entitlement.plist file path."); // define a optional query
codesign.setQuery(@"cert").setAbbr('c').require().setExplain("Cert name"); // define a require query
[CLCommand setDefaultTask:^CLResponse *(CLCommand *command, CLRequest *request) {
    NSString *cert = request.queries[@"cert"]; // get value with key.
    NSString *entitlement = request.queries[@"entitlement"]; // nonable
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
CLCommand *ls = [CLCommand sharedCommand]; // get main command (without any command or subcommands)
ls.setFlag(@"all").setAbbr('a').setExplain(@"Print all contents."); // define a optional query
[CLCommand setDefaultTask:^CLResponse *(CLCommand *command, CLRequest *request) {
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

### IOPaths

IOPaths is a type of value without any key. It's usually used in input, output path. Such as:

```shel
$ cd /change/to/directory/		# inpuut
$ mkdir /create/new/folder		# input
$ zip /to/.zip /source/folder	# output & input
```

you can execute the code before parse.

```objc
CLCommand *zip = [CLCommand sharedCommand]; // get main command (without any command or subcommands)

/*
	User must type in an output path and one or more input path(s)
*/
zip.addRequirePath(@"output").setExplain(@"output key");
zip.addRequirePath(@"input1").setExplain(@"Input path");
zip.addOptionalPath(@"input2").setExplain(@"Input path");
[CLCommand setDefaultTask:^CLResponse *(CLCommand *command, CLRequest *request) {
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



### Helping Infomation

When should the tool print helping infomation ?

1. User type in `--help` or `-h` for helping
2. User type in illegal arguments. Such as: inputed 2 paths but 3 required, didnot input required query...

**CommandLine** will auto create a colorfull helping infomation and print automatically.

**Colorfull helping infomation ?** Yes ! Just like *CocoaPods*.

### Verbose

Print more infomations mode.

It will be triggered by flag `--verbose`. 

You can use in task:

```objective-c
[request verbose:@"Making temp directory: %@", tempDirectory];
//	it will be print if the request contains `verbose` flag.
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

### Print colorful text

```objc
[CCText print:CCStyleBord|CCStyleItalic format:@"A text with %@ and %@", @"bord", @"italic"];
```

## LICENCE

MIT.
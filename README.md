# Introduction #

This source code is the one I have used as exercises for the Ironhack
training.  I am responsible for teaching the Core Data and Testing
(unit testing, TDD) week and I decided to create this examples that
can be used as exercises.  Feel free to use them. And if you are
interested in more code like this, I do contract work. Contact me:
- Email: jortiz -at- powwau.com
- Twitter: jdortiz

The core contents of the week are about the model part of an
application. In the examples I won't purposely focus on the visual
part: no autolayout constraints, no fancy animations, no problem with
poor ux.

Git is assumed. ALWAYS commit after each section of the exercises.  The
repo has been created with that philosophy, each section corresponds
to a commit. Thus, you can checkout the version before the exercise
and compare it with the next commit to check my answer to the
exercise.

I do know that not all the answers are optimal, some will have to be
improved for performance in production code. However:

1. I am against of premature optimization.
2. I rather favor legibility than performance.
3. These examples are meant for other people to understand what is
   going on and learn from them.

# Exercises #

## Basic Core Data demo ##

Full use of Core Data the "hard way", using KVC.

### Create project (2 min) ###

Learn the basics.

1. Open Xcode
2. New project iOS -> Application -> Master-Detail Application
3. Product Name: "Malometer", Devices: "iPhone", Select "Use Core
   Data"
4. Choose directory and maintain create git repository selected.

### Review project template contents (5 min) ###

Understand how the template works.

1. Visit Malometer.xcdatamodeld: 1 entity, 1 attribute.
2. Visit Main.storyboard: Expected screens. No buttons!
3. Visit MasterViewController.m:
   1. Buttons added in code?
   2. Coupling between VC and model (Example insertNewObject)
4. Run the app to see how it works.

### Changes to the model (10 min) ###

Use our own model with the template.

1. Edit the name of the entity in the model. Change it to Agent.
2. Delete the attribute.
3. Create 3 new attributes:
   1. name :: String, not optional, indexed
   2. destructionPower :: Integer 16, not optional
   3. motivation :: Integer 16, not optional
4. Run it and it will crash. From the terminal

    $ cd ~/Library/Application\ Support/iPhone\ Simulator
    $ find . -name Malometer.app
    $ cd <path>/Documents
    $ rm Malometer.sqlite*

### Change the query of the fetchedResultsController (2 min) ###

Make the table display the agents (for when they are ready later).

1. Run it and it will crash. The name of the entity and the attribute in
   fetchedResultsController are wrong. Change them.
2. Change the name of the entity to "Agent" and the attribute to "name"

### Modify the view controller to add model objects (20 min)  ###

Create a new view controller that will later allow to edit the agent
data. In this step, only the views are put in place and the basic
initialization.

1. Rut it again and tap on the plus button at the top. It will crash
   because the creation still uses the attribute timeStamp. Shouldn't
   we change it once for all the code?
2. Comment out the insertNewObject method.
3. Remove the creation of the add button in viewDidLoad and comment
   out the creation of the edit button.
4. Time to edit the detail view controller to populate the fields. Use
   the storyboard to create these fields in the viewcontroller:
   1. Delete the existing label.
   2. Add five labels.
   3. Add one textfield and configure its parameters..
   4. Add two steppers and configure its parameters.
5. In the detail view controller header, define IBOutlets for the
   three labels that will change, the text field and the two steppers.
6. Connect the outlets to their respective object in interface
   builder.
7. Initialize each of the controls in viewDidLoad. Use arrays for the
   named values of the 3 properties of the agent object.

### Connect the view controllers for creating agents (10 min) ###

Have a segue that works to enable editing newly created agents.

1. Delete the existing segue that connects master and detail view
   controllers.
2. Embed the view controller in a navigation vc.
3. Add a new "+" button to the master view controller.
4. Create a modal segue from the button to the detail view controller
   and name it "CreateAgent".
5. Change the name of the property of the detail view controller from
   detailItem to agent.
6. Modify the metod prepareForSegue of the master view controller:
   1. Define a constant string for the class with the name of the
      segue.
   2. Extract the destination view controller.
   3. Create a new agent object.
   4. Pass it to the detail view controller
7. Run and test. Notice there is no way to go back.

### Add actions to the Agent edit view controller (20 min) ###

Respond to the events of the interface in the view controller used for
editing that make the user go back to the main view controller.

1. Add new header file with the protocol to dismiss the view
   controller. (1 method, modifiedData)
2. In the detail, import the new header and define a delegate property.
3. Make the header of the master implement the protocol.
4. Assign the delegate in the prepareForSegue of the master.
5. Implement the method in the master that dismisses the view
   controller. (No data saving yet)
6. Define the two actions for each bar button in the detail view
   controller.
7. In the storyboard create two bar buttons to cancel and save the
   contents of the detail view controller.
8. Connnect them  with their respective actions.
9. Run it and it will throw an error. Change the attribute name of the
   configureCell method.

### Create actions for the controls of the detail view controller (10 min) ###

Define actions to respond to the events generated by the steppers and
use that data in the saving process.

1. Inside of the save action include a method to read the values from
   the text field and applies it to the agent object.
2. Define a new method to deal with the destruction power changes and
   apply those changes to the assessment value.
3. Connect the method to stepper for the destruction value.
4. Run and verify that the labels aren't updated.
5. Create the analogous method for the motivation stepper and connect it.

### Show the updated values of the agent object in the view controller (10 min) ###

Update the labels of interface when the values change. This is done by
pushing the changes.

1. Add a method for each label to display its value based on the
   respective agent property.
2. Invoke the required methods in each of the stepper actions.
3. Refactor viewDidLoad
4. Run and verify that the labels are updated.
5. Verify that the steppers only change within the expected range or
   solve in Interface Builder.

### Persist the data (15 min) ###

Use the undo manager to forget about objects that the user decides
cancelling their creation. Save the context to make the (not-undone)
changes persistent (in the file system).

1. Review the app delegate, the section of the Core Data Stack.
2. Create an undo manager and assign it to the moc. Configure it to
   not create groups by event and limit the number of undos to 10.
3. Begin an undo group before creating the new object in the master
   view controller.
4. Set the action name for the undo operation and end the undo group
   in the method that is used to dismiss the detail view controller.
5. If modified data should be preserved, call the save method of the context.
6. If modified data should be dismissed, rollback the change.

### Janitorial changes (5 min) ###

Cleaner code.

1. Remove commented out code.
2. Rename the detail view controller to AgentEditViewController using
   the refactoring capabilities of Xcode.
3. Rename the Master view controller to AgentsViewController.

## Subclassing the managed object ##

This is the way Core Data is commonly used. Objective-C objects are
mapped to the database with their properties and methods.

### Create Agent as a subclass of MO (10 min) ###

Have the class ready to be able to use it in the rest of the
code. Use properties instead of KVC.

1. Use Xcode to generate the subclass.
2. Review the generated subclass.
3. Replace the code to use the properties in the Agents view controller.
   1. Import the Agent.h header
   2. Change configureCell.
   3. Change the type of the object created in your prepare for segue
      method.
4. Replace the code to use the properties in the Agent edit view controller.
   1. Change its header so the agent type is Agent * using a forward
      declaration.
   2. Import the Agent.h header in the implementation file.
   3. Replace all the invocation to setValue:forKey: and valueForKey:
      by the corresponding properties.

### Observing the model (15 min) ###

Be able to react to changes in the model instead of pushing them from
the events.

1. Remove the call to the method that updates the label of the
   destruction power from the action assigned to its stepper.
2. Add the view controller as an observer for the keypath
   agent.destructionPower in viewWillAppear
3. Remove the observer in viewDidDisappear
4. Write the method to respond to the value changes so it updates the
   text of the label.
5. Run and test that the label is updated.
6. Repeat for the same sequence for the motivation attribute.

### Move logic to the model (20 min) ###

Understand the value provided by transient properties. Have properties
that depend on other properties.

The way to calculate assessment is part of the model. However, it is
outside of the model itself.

1. Create a new attribute in the model: assessment: int16, transient,
   non optional.
2. Chech Agent.h and Agent.m. Nothing has changed, they must be
   regenerated. Do so.
3. Create the getter for it in the implementation file that uses the
   equation to calculate the assessment and returns it.
4. Use it in the method to display the assessment.
5. Remove the call to the method that updates the label of the
   assesment from the actions assigned to both steppers.
6. Add an observer for its keypath. Run and check that it doesn't work.
7. Add calls to the getter notify that the value will/did change for
   the assessment key.
8. Tell Core Data that the value of assessment depends on the other
   two attributes. ((NSSet *)keyPathsForValuesAffectingAssessment).
9. Refactor the actions assigned to the setters.

### More properties and primitive values for dependencies in categories (20 min) ###

Understand how the custom setters and getters in Core Data and how to
define dependencies in a category.

1. Create a new string attribute called pictureURL (optional, not indexed).
2. Regenerate the subclass.
3. Verify the regenerated files and notice what is missing.
4. Create a "Model" category of the agent class.
5. Recover the model logic code from the previous git commit and put
   it in the Model category.
6. Run it. It will crash. Remove the database, run it again and test
   the model logic. WARNING: the results here MAY vary.
7. Put two breakpoints in the two methods of the logic model and
   notice that the class method (might not) isn't called.
8. Create constant strings for the properties in the category
   implementation and declare them as extern in the header.
9. In any case, create setters for the motivation and the destruction
   power that update the primitive value of assessment and get rid of
   the class method.

### Revisiting model logic (15 min) ###

Make the interface easier to use, and the created objects editable
using a second segue to the same view controllers.

1. Add to the agent edit view controller the delegate method for the
   text field that alows the keyboard to be dismissed. And connect the
   view controller to the text field as delegate.
2. Create another segue to the navigation controller connected to the
   agent in order to revie and visit agent objects when they are
   selected from the table.

### Assign and view the picture (1:30h) ###

Have the user interface required to select/edit/delete images.

1. Move all the controls of the agent edit view controller downwards
   to leave space for the picure.
2. Create a 100x100 button with the label "Add image"
3. Create an action in the view controller that shows an action sheet
   (Take photo, Select photo, Delete photo).
4. Make the view controller and action sheet delegate and add the
   method that responds to the action sheet options.
5. Use UIImagePickerVC to obtain the images from the user.
6. Persistence of the images must be a separated object (SRP).

## Relationships and Predicates ##

Having the data inside of the database is important, but it is even
more important to be able to extract the data that we want from it.

### Move the query to the model (15min) ###

Queries are part of the model, so they belong there.

1. Add a class method to the Agent category that provides the fetch
   request used by the fetch results controller of the agents view
   controller.
2. Try it with fetched results controller. Verify the order.
3. Create a similar request with a predicate as a parameter. Use it to
   filter out the agents with a destruction power smaller than 2.

### Create relationships (10 min) ###

Relationships is one of the most powerful features of Core Data. Let's
define the model to be able to use them.

1. Define 2 new entities:
   1. "FreakType": with attribute "name": string, non optional,
      indexed and relationship "agents", optional, cardinality: 1 category includes
      many agents, delete rule: cascade. Reverse relationship
      "category", optional, delete rule, nullify.
   2. "Domain": with atribute "name": string, non optional, indexed
      and relationship "agents", optional, cardinality 1 domain has many
      agents, delete rule: denay. Reverse relationship "domains", 1 agent works in many
      domains, delete rule: nulify.
2. Regenerate the subclasses (all three). And delete the database,
   once again.

### Create controls to edit the category and domains (30 min) ###

Modify the user interface to be able to use the relationships.

1. Add two text fields besides the picture.
2. Add two iboutlets for them in the agent edit view controller
   header, connect them and set the view controller as delegate.
3. Create a method that, when the text field has finished being
   edited, parses the string (spliting by commas for the domains, and
   nothing for the category) and creates an attributed string decides
   with green colors for objects that already exist, and red for the
   ones that don't. The implementation of whether they exist or not
   will be done later.

### Work with relationships (20 min) ###

Add logic to the FreakType entity that will make working with
relationships easier.

1. Create a convenience constructor for the FreakType that uses a name.
2. Create a class method that returns the FreakType with the provided
   name in the given managed object context.
3. Use those two methods when saving the agent.
4. Create the analogous methods for the domains. Keep in mind that the
   relationship with the domains is expressed using a NSSet.

### Sorting the results (10 min) ###

Demonstrate different ways to sort the data. Understant the
limitations of transient attributes.

1. Create a new method of the Agent, that generates a fetch request
   sorted with the provided sort descriptors. Run it and see the results.
2. Use the same method sorting by assesment. Run it and see what happens.
3. You can also sort by more than one criteria. Try sorting by
   destruction power and then by name.

### Fetch request (10 min) ###

Use relationship based sections in the table view.

1. Modify the fetch results controller to use the category name as section.
2. Add the table view data source method to return the name of the
   section from the corresponding object of the sections array in the
   fetched results controller.
3. Complete the section header title with the average of the
   destruction power of the members of that section.
4. Create a fetch request of the domains that returns those which
   have more than one agent with a destruction power of 3 or more.
5. Calculate the number of results and display it in the title.
6. Refresh it after controller did finish.

### Exercises for the reader (15 min) ###

- Complete the CRUD. Delete an object when the user swipes over one of the table rows.

## Unit testing demo: Testing the app delegate ##

Install the test Template.

### Test return value: Sut not nil ###

Understand how to test a method for a return value.

1. Delete existing unit test file.
2. Under the MalometerTests folder create an "AppDelegate" group.
3. Create the Test class for the app delegate.
4. Remove from it all the Core Data related code.
5. Validate the "sut is not nil" test.

### Test state: managedObjectContext ###

Understand how to test a method that changes the state of the object.

1. Check that the managed object context is created when accessed.

### Test behavior: saving the data of a managed object context ###

Understand how to test a method that uses other objects.

1. Add a test to check that the saveContext method tells the
   managedObjectContext to save the changes.
2. Create a subclass of MOC in the same file (mocFake).
3. Create an instance of that class in the test and inject it into the
   sut using kvc.
4. Override the hasChanges method to return YES.
5. Create a BOOL property to record the changes.
6. Set the property to YES in the overriden save: method.
7. Verify that it is yes.

### Exercises for the reader (30 - 45 min) ###

- Test app documents directory is not nil, is a directory (not a
  file), contains Documents as the last component of the path...
- Test the managed object model and the persistent store coordinator
  are created when the managed object context is accessed.
- Test the root view controller is assigned the managed object context
  on launch.

## Testing Core Data ##

### Basic test of a model class (10 min) ###

1. Create a unit test for the agent with the provided template, inside
   of a new "Model" group.
2. Run and verify that it fails, because the object isn't created
   properly.
3. Uncomment and verify the creation and release of the Core Data stack.
4. Use Agent+Model.h instead of just Agent.h when importing into the
   test file.
5. Make the entity name shared.
6. Change the createSut method to create an agent ala Core Data.
7. Run and verify that it fails.
8. Include the model in the unit test target.
9. Run and verify that it works.

## Versioning & migration ##

Understand how to change the model in a controller way. Be sure to
have some data loaded (at least 3 agents for the examples).

### Identifying the current model version (5 min) ###

Understand the current status of the model.

1. Run the program to check that it runs and displays the current data.
2. In the file inspector of the model fill in a new version
   identifier (1.0.0).
3. Run the program again to see that nothing has changed.
4. Using the terminal, go to the directory where the sqlite of the
   project is. Execute the following command and keep what follows
   NSStoreModelVersionHashesVersion resulting from the last one.

    $ sqlite Malometer.sqlite
    $ select * from sqlite_master where type='table';
    $ select * from Z_METADATA;
    $ .quit

### Adding a new model version (10 min) ###

Create a the new version of the model.

1. Add a new model version (Editor -> Add Model Version...)
2. In the new model, add a new attribute to the Agent entity (Power:
   string, optional, not indexed.
3. Edit the model version identifier of the new one to have the right one.
4. Run and it will not crash.
5. Check the hash and see that it is still the same.
6. In the inspector of the model change the current model version to
   the new one.
7. Run and it will crash. The value of
   NSStoreModelVersionHashesVersion will continue being the same.

### Lightweight migration (5 min) ###

Let Core Data take care of the required changes to the data based on
the new model.

1. In the persistentCoordinator getter of the app delegate, create a
   new dicionary for the options to use with the persistent store.
2. Add options to make automatic migration of the store and infer the
   mapping automatically and pass them to the persistent store
   addition process.
3. Run it. It will not crash, but we haven't made any change to the
   interface to know that the change has actually happened.

### Verifying the change (5 min) ###

Check that the expected change has happened.

1. Add a breakpoint to any method that uses an Agent object. For
   example AgentsViewController's configureCell:atIndexPath:.
2. Run 'po agent' in the debugger and verify that power is one of the
   attributes.
3. In the terminal chech that the string after
   NSStoreModelVersionHashesVersionhas finally changed. The store has
   been migrated.

### Populate data to preserve (10 min) ###

Prepare data for the next, more complex, migration.

1. Regenerate the Agent subclass.
2. In order to have some data add line in the prepareForSegue part of
   the edit view controller to set the power to Intelligence if the
   row is an even number or Strength if it is odd.
3. Run it visit some (not all) of the agents and remember to save them.
4. Use the debuger to print the fetchedObjects of the
   fetchedResultsController to verify that the data has been created.
5. Close the application by quiting it from the simulator (task
   manager) and query the sqlite database to double-check that the
   data is there.
6. Preserve a copy of the current database. Query that copy to ensure
   that the data is there. (MD5s appreciated).

### A new model with complex changes (15 min) ###

Now our goal is to be able to have many powers per agent (a many to
many relationship). Create the model for it.

1. Add a new model based on Malometer 1.1.0 and call it Malometer2.
2. Edit its identifier.
3. Create a new entity Power with one attribute name: string, non
   optional, indexed.
4. Create a to-many relationship in Agents: powers, and the inverse
   relationship in Power, agents that is also to-many.
5. Remove the power attribute of the Agent entity.
6. Regenerate the Agent and Power entities.
7. Create a Model category of the Power class.
8. Create a class method in Power to fetch a power with a given name
   in a given MOC.
9. Build it, but DON'T Run the app or else it will loose the data,
   because lightweight migration is enabled. (if you make 2 the
   current version).

### Create the mapping (20 min) ###

Provide the required information to preserve the names of the existing
powers into the new entities, without duplicating them.

1. Create a new file, Mapping Model, from version 1.1.0 to 2.0.0.
2. Inspect (but don't change) the newly created mapping.
3. In the AgentToAgent entity mapping notice that there is the
   posibility to create a custom policy.
4. Create subclass of NSEntityMigrationPolicy and call it AgentToAgentMigrationPolicy.
5. Override the method
   createDestinationInstancesForSourceInstance:entityMapping:manager:error:
   It must do 4 things:
   1. Create the destination instance (an Agent in the destination
      context).
   2. Transfer the atributes from the source to the destination one.
   3. Extract a pawer instance with the name of the attribute (or use
      the already existing one) and relate it with the destination instance.
   4. Tell the migration manager to associate the source and
      destination instances.
6. Use this class as the name of the custom policy for the Agents mapping.
7. Make version 2 the current version of the model.
8. Run and check with the debugger that the relationships exists. For
   any object that had a power in the previous dataset,
    po [[agent.powers anyObject] name]

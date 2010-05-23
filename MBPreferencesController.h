//
//  MBPreferencesController.h
//
//  Created by Matt Ball on 9/30/08.
//
//  See LICENSE.md file in the PlayerPiano source directory, or at
//  http://github.com/amazingsyco/PlayerPiano/blob/master/LICENSE.md
//

#import <Cocoa/Cocoa.h>

/**
 * @protocol    MBPreferencesModule
 *
 * @brief       All modules to be installed in a MBPreferencesController-driven preferences
 *              window must conform to the MBPreferencesModule protocol. This ensures that
 *              MBPreferencesController has enough information to accurately populate the
 *              toolbar.
 */
@protocol MBPreferencesModule
/**
 * @name		Module Attributes
 */
@required
/**
 * @brief       The title of the module.
 * @details     This value will be used for the toolbar item's label as well as the window's
 *              title when the module is active.
 */
- (NSString *)title;

/**
 * @brief		A unique identifier to represent the module.
 */
- (NSString *)identifier;

/**
 * @brief       The icon to display in the module's toolbar icon.
 */
- (NSImage *)image;

/**
 * @brief       The view which should be displayed when the module is active.
 */
- (NSView *)view;
@optional

/**
 * @brief       Sent to indicate that the module is about to become active.
 * @details     This is useful if, for example, one of an application's modules
 *              requires some slower calculations in order to populate its views.
 *              Calculations of this sort should be deferred until the module becomes
 *              active to avoid slowdowns in cases where the user never activates the
 *              module in question.
 */
- (void)willBeDisplayed;
@end

/**
 * @class       MBPreferencesController
 *
 * @brief       MBPreferencesController provides an easy, reusable implementation
 *              of a standard preferences window.
 * @details     MBPreferencesController handles the creation and display of the preferences
 *              window as well as switching between different "modules" using the toolbar.
 */
@interface MBPreferencesController : NSWindowController<NSToolbarDelegate> {
	NSArray *_modules;
	id<MBPreferencesModule> _currentModule;
}

/**
 * @name        Accessing the Shared Instance
 */

/**
 * @brief       The shared controller for the application's preferences window.
 *              All interaction with the window should be done through this controller.
 */
+ (MBPreferencesController *)sharedController;

/**
 * @name        Preference Modules
 */

/**
 * @brief       The different modules to install into the preferences window.
 * @details     Each item in the array must conform to the MBPreferencesModule
 *              protocol. It is suggested (but not required) that these items
 *              be subclasses of \c NSViewController.
 *
 *              Changing this value will result in the toolbar being cleared and
 *              repopulated from the ground up. As such, the modules should usually
 *              be set once and left that way.
 *
 * @see         moduleForIdentifier:
 */
@property(retain) NSArray *modules;

/**
 * @brief       The preference module that corresponds to the given identifier.
 *
 * @param       identifier	The identifier in question.
 *
 * @return      The preference module that corresponds to \c identifier, or \c nil
 *              if no corresponding module exists.
 *
 * @see         modules
 */
- (id<MBPreferencesModule>)moduleForIdentifier:(NSString *)identifier;

@end

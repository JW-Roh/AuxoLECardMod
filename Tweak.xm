

@interface AuxoAnimator : NSObject
- (void)animateFrom:(CGFloat)arg1 to:(CGFloat)arg2 duration:(NSTimeInterval)arg3;
- (void)animateFrom:(CGFloat)arg1 to:(CGFloat)arg2 duration:(NSTimeInterval)arg3 startVelocity:(CGFloat)arg4;
@end

@interface AuxoCardView : UIView
@property(readonly, nonatomic) NSString *displayIdentifier;
@end

@interface AuxoCollectionViewCell : UICollectionViewCell
@property(readonly, nonatomic) AuxoCardView *cardView;
@end

@interface AuxoCollectionView : UICollectionView {
	AuxoCollectionViewCell *justSelectedCell;
	BOOL interactivelyAnimating;
}
+ (id)activeCollectionView;
- (void)auxoCardViewWantsToClearAll:(id)arg1;
- (void)commitClearAll;
- (void)auxoCardViewWantsToClose:(id)arg1;
@property(nonatomic) CGFloat interactiveActivationProgress;
- (id)pageForDisplayIdentifier:(id)arg1;
@end



// iOS 7 {{{
@interface BKSApplicationProcessInfo : NSObject
@property(copy, nonatomic) NSString *bundleIdentifier;
@end
// }}}


@interface SpringBoard : UIApplication
- (id)_accessibilityFrontMostApplication;
- (BOOL)isLocked;
@end

@interface SBApplication : NSObject
- (NSString *)bundleIdentifier;
- (BOOL)isRunning;
@end
@interface SBApplication (firmware7)
- (id)mainScreenContextHostManager;
@end
@interface SBApplication (firmware8)
- (id)mainSceneID;
- (id)mainScene;
@end

@interface SBApplicationController : NSObject
+ (id)sharedInstanceIfExists;
+ (id)sharedInstance;
@end
@interface SBApplicationController (firmware7)
- (id)applicationWithDisplayIdentifier:(id)fp8;
@end
@interface SBApplicationController (firmware8)
- (id)applicationWithBundleIdentifier:(id)fp8;
@end
@interface SBApplicationController (new_method)
- (SBApplication *)__auxole_mod_applicationWithIdentifier:(NSString *)identifier;
@end

// iOS 7 {{{
@interface SBWorkspaceEvent : NSObject
+ (id)eventWithLabel:(NSString *)fp8 handler:(void(^)(void))handler;
- (void)execute;
@end
@interface SBWorkspaceEventQueue : NSObject
+ (instancetype)sharedInstance;
- (BOOL)hasEventWithName:(NSString *)fp8;
- (BOOL)hasEventWithPrefix:(NSString *)fp8;
- (void)cancelEventsWithName:(NSString *)fp8;
- (void)executeOrAppendEvent:(id)fp8;
@end
// }}}

@interface SBWorkspace : NSObject
- (void)setCurrentTransaction:(id)fp8;
@end
@interface SBWorkspace (firmware7)
- (id)currentTransaction;
- (id)_selectTransactionForAppActivationToApp:(SBApplication *)fp8 activationHandler:(void(^)(void))handler;
- (id)_selectTransactionForReturningToTheLockScreenWithActivationHandler:(void(^)(void))handler;
@end
@interface SBWorkspace (firmware8)
- (id)_selectTransactionForAppActivationToApp:(id)fp8 withResult:(id)block;
- (id)_selectTransactionForReturningToTheLockScreenWithResult:(id)block;
@end

// iOS 7 {{{
@interface SBWindowContextHostManager : NSObject
- (id)identifier;
- (void)disableHostingForRequester:(id)fp8;
- (void)hideHostViewOnDefaultWindowForRequester:(id)fp8 priority:(NSInteger)fp12;
- (void)hideHostViewOnDefaultWindowForRequester:(id)fp8;
- (void)unhideHostViewOnDefaultWindowForRequester:(id)fp8;
@end

@interface SBAppSliderController : NSObject
- (void)_updateSnapshots;
@end
// }}}

@interface SBUIController : NSObject
+ (id)sharedInstanceIfExists;
+ (id)sharedInstance;
- (id)switcherController;
- (BOOL)isAppSwitcherShowing;
@end



// iOS 8 {{{
@interface FBProcess : NSObject
@property(readonly, copy, nonatomic) NSString *bundleIdentifier;
@end

@interface FBApplicationProcess : FBProcess @end


@interface BSEventQueueEvent : NSObject
+ (id)eventWithName:(NSString *)name handler:(void(^)(void))handler;
- (void)executeFromEventQueue;
- (void)execute;
@end
@interface FBWorkspaceEvent : BSEventQueueEvent
- (void)execute;
@end
@interface BSEventQueue : NSObject
@property(retain, nonatomic) BSEventQueueEvent *executingEvent;
- (BOOL)hasEventWithName:(id)arg1;
- (BOOL)hasEventWithPrefix:(id)arg1;
- (void)cancelEventsWithName:(id)arg1;
@end
@interface FBWorkspaceEventQueue : BSEventQueue
+ (id)sharedInstance;
- (void)executeOrPrependEvent:(id)arg1;
- (void)executeOrAppendEvent:(id)arg1;
@end


@interface FBScene : NSObject
@property(readonly, retain, nonatomic) FBProcess *clientProcess;
@property(readonly, copy, nonatomic) NSString *identifier;
@end
@interface FBSceneManager : NSObject
+ (id)sharedInstance;
- (id)sceneWithIdentifier:(id)arg1;
- (id)hostManagerForSceneID:(id)arg1;
@end
@interface FBWindowContextHostManager : NSObject
@property(readonly, nonatomic) FBScene *scene;
@property(copy, nonatomic) NSString *identifier;
- (void)disableHostingForRequester:(id)arg1;
- (id)hostViewForRequester:(id)arg1 enableAndOrderFront:(BOOL)arg2;
- (id)hostViewForRequester:(id)arg1;
@end

@interface SBAppSwitcherController : NSObject
- (void)_updateSnapshotsForce:(BOOL)fp8;
- (void)_updateSnapshots;
- (void)_rebuildAppListCache;
@end
// }}}




extern "C" {
	NSString *BKSApplicationTerminationReasonDescription(int reason);
	BOOL BKSApplicationTerminationReasonIsGraceful(NSString *app);
	void BKSTerminateApplicationForReasonAndReportWithDescription(NSString *app, int a, int b, NSString *description);
}


#define DEFAULT_MAX_ALPHA				1.0f
#define DEFAULT_MIN_ALPHA				0.5f
#define DEFAULT_DOWN_THRESHOLD			170.0f
#define DEFAULT_UP_THRESHOLD			1.0f
#define DEFAULT_RETURN_DURATION			0.3f


static SBWorkspace *g_sbWorkspace = nil;
static BOOL nowCoveredAppIsDeactivating = NO;
static BOOL springBoardLoaded = NO;

static CGFloat g_minAlpha = DEFAULT_MIN_ALPHA;
static BOOL g_keepCardView = YES;



void killApplicationForReasonAndReportWithDescription(NSString *bundleIdentifier, int reason, BOOL report, NSString *desc)
{
	if (desc == nil)
		desc = BKSApplicationTerminationReasonDescription(reason);
	
	NSString *label = [NSString stringWithFormat:@"TerminateApp: %@ (%@)", bundleIdentifier, desc];
	
	// iOS 7
	if (%c(SBWorkspaceEvent)) {
		SBWorkspaceEvent *event = [%c(SBWorkspaceEvent) eventWithLabel:label handler:^{
			BKSTerminateApplicationForReasonAndReportWithDescription(bundleIdentifier, reason, report, desc);
		}];
		
		SBWorkspaceEventQueue *eventQueue = [%c(SBWorkspaceEventQueue) sharedInstance];
		[eventQueue executeOrAppendEvent:event];
	}
	// iOS 8
	else if (%c(FBWorkspaceEvent)) {
		FBWorkspaceEvent *event = [%c(FBWorkspaceEvent) eventWithName:label handler:^{
			BKSTerminateApplicationForReasonAndReportWithDescription(bundleIdentifier, reason, report, desc);
		}];
		
		FBWorkspaceEventQueue *eventQueue = [%c(FBWorkspaceEventQueue) sharedInstance];
		[eventQueue executeOrAppendEvent:event];
	}
}


void quitTopApp()
{
	SBApplication *application = [(SpringBoard *)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
	
	if (![application isRunning]) return;
	
	// iOS 7
	if (%c(SBWorkspaceEvent)) {
		SBWorkspaceEventQueue *eventQueue = [%c(SBWorkspaceEventQueue) sharedInstance];
		if ([eventQueue hasEventWithName:@"QuitTopApp"])
			return;
		
		SBWorkspaceEvent *event = [%c(SBWorkspaceEvent) eventWithLabel:@"QuitTopApp" handler:^{
			nowCoveredAppIsDeactivating = YES;
			[[application mainScreenContextHostManager] hideHostViewOnDefaultWindowForRequester:@"Control Center"];
			
			if ([(SpringBoard *)[UIApplication sharedApplication] isLocked])
				[g_sbWorkspace setCurrentTransaction:[g_sbWorkspace _selectTransactionForReturningToTheLockScreenWithActivationHandler:nil]];
			else
				[g_sbWorkspace setCurrentTransaction:[g_sbWorkspace _selectTransactionForAppActivationToApp:nil activationHandler:nil]];
			nowCoveredAppIsDeactivating = NO;
		}];
		[eventQueue executeOrAppendEvent:event];
	}
	// iOS 8
	else if (%c(FBWorkspaceEvent)) {
		FBWorkspaceEventQueue *eventQueue = [%c(FBWorkspaceEventQueue) sharedInstance];
		if ([eventQueue hasEventWithName:@"QuitTopApp"])
			return;
		
		FBWorkspaceEvent *event = [%c(FBWorkspaceEvent) eventWithName:@"QuitTopApp" handler:^{
			nowCoveredAppIsDeactivating = YES;
			FBSceneManager *sm = [%c(FBSceneManager) sharedInstance];
			FBWindowContextHostManager *chm = [sm hostManagerForSceneID:application.mainSceneID];
			[chm disableHostingForRequester:@"Control Center"];
			
			if ([(SpringBoard *)[UIApplication sharedApplication] isLocked])
				[g_sbWorkspace setCurrentTransaction:[g_sbWorkspace _selectTransactionForReturningToTheLockScreenWithResult:nil]];
			else
				[g_sbWorkspace setCurrentTransaction:[g_sbWorkspace _selectTransactionForAppActivationToApp:nil withResult:nil]];
			nowCoveredAppIsDeactivating = NO;
		}];
		[eventQueue executeOrAppendEvent:event];
	}
}




%group AuxoLegacyEdition

%hook AuxoCardView

- (void)loadDisplayIdentifier:(NSString *)displayIdentifier withQueue:(id)queue {
	%orig;
	
	SBApplicationController *ac = [%c(SBApplicationController) sharedInstanceIfExists];
	self.alpha = [[ac __auxole_mod_applicationWithIdentifier:displayIdentifier] isRunning] ? DEFAULT_MAX_ALPHA : g_minAlpha;
}

- (void)layoutSubviews {
	%orig;
	
	SBApplicationController *ac = [%c(SBApplicationController) sharedInstanceIfExists];
	self.alpha = [[ac __auxole_mod_applicationWithIdentifier:self.displayIdentifier] isRunning] ? DEFAULT_MAX_ALPHA : g_minAlpha;
}

%end

%hook AuxoCollectionView

- (void)panGestureUpdated:(id)gesture {
	%orig;
	
	BOOL interactivelyAnimating = MSHookIvar<BOOL>(self, "interactivelyAnimating");
	if (interactivelyAnimating) {
		AuxoCollectionViewCell *justSelectedCell = MSHookIvar<AuxoCollectionViewCell *>(self, "justSelectedCell");
		
		SBApplicationController *ac = [%c(SBApplicationController) sharedInstanceIfExists];
		
		if (![[ac __auxole_mod_applicationWithIdentifier:justSelectedCell.cardView.displayIdentifier] isRunning])
			justSelectedCell.cardView.alpha = g_minAlpha + self.interactiveActivationProgress * fabs(DEFAULT_MAX_ALPHA - g_minAlpha);
		else
			justSelectedCell.cardView.alpha = DEFAULT_MAX_ALPHA;
	}
}

- (void)auxoCardViewWantsToClose:(AuxoCardView *)cardView {
	if (g_keepCardView) {
		SBApplicationController *ac = [%c(SBApplicationController) sharedInstanceIfExists];
		SBApplication *application = [ac __auxole_mod_applicationWithIdentifier:cardView.displayIdentifier];
		
		if (![application isRunning]) return;
		
		SBApplication *frontmostApp = [(SpringBoard *)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
		
		if (application == frontmostApp) {
			quitTopApp();
		}
		
		killApplicationForReasonAndReportWithDescription(cardView.displayIdentifier, 1, NO, @"killed from AuxoLegacyEdition");
	}
	else {
		%orig;
	}
}

- (void)activateApplicationWithDisplayIdentifier:(NSString *)identifier fromCell:(id)cell {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		Class EventQueueClass = Nil;
		Class EventClass = Nil;
		SEL EventWithName = Nil;
		
		// iOS 7
		if (%c(SBWorkspaceEvent)) {
			EventQueueClass = %c(SBWorkspaceEventQueue);
			EventClass = %c(SBWorkspaceEvent);
			EventWithName = @selector(eventWithLabel:handler:);
		}
		// iOS 8
		else if (%c(FBWorkspaceEvent)) {
			EventQueueClass = %c(FBWorkspaceEventQueue);
			EventClass = %c(FBWorkspaceEvent);
			EventWithName = @selector(eventWithName:handler:);
		}
		
		id eventQueue = [EventQueueClass sharedInstance];
		BOOL flag = NO;
		while ([eventQueue hasEventWithName:@"QuitTopApp"] || [eventQueue hasEventWithPrefix:@"TerminateApp:"]) {
			flag = YES;
			usleep(10*1000);
		}
		if (flag) usleep(100*1000);
		
		dispatch_async(dispatch_get_main_queue(), ^{
			NSString *name = [NSString stringWithFormat:@"ActivateApplication %@ from AuxoCardView", identifier];
			if ([eventQueue hasEventWithName:name]) return;
			
			id event = [EventClass performSelector:EventWithName withObject:name withObject:^{
				%orig;
			}];
			
			[eventQueue executeOrAppendEvent:event];
		});
	});
}

%end

%hook AuxoAnimator

- (BOOL)completeWithVelocity:(CGFloat)velocity cancelValue:(CGFloat)cancelThreshold successValue:(CGFloat)successThreshold {
	BOOL down = (successThreshold > DEFAULT_UP_THRESHOLD);
	BOOL rtn = %orig;
	
	if (down && rtn && g_keepCardView) {
		[self animateFrom:DEFAULT_DOWN_THRESHOLD to:0.0f duration:DEFAULT_RETURN_DURATION];
	}
	
	return rtn;
}

%end

%end



%hook SBWorkspace

// iOS 7 {{{
- (void)workspace:(id)workspace applicationExited:(NSString *)identifier withInfo:(id)info {
	%orig;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		AuxoCollectionView *acv = [%c(AuxoCollectionView) activeCollectionView];
		AuxoCollectionViewCell *page = [acv pageForDisplayIdentifier:identifier];
		page.cardView.alpha = g_minAlpha;
	});
}

- (void)workspace:(id)workspace applicationDidStartLaunching:(BKSApplicationProcessInfo *)processInfo {
	%orig;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		AuxoCollectionView *acv = [%c(AuxoCollectionView) activeCollectionView];
		AuxoCollectionViewCell *page = [acv pageForDisplayIdentifier:processInfo.bundleIdentifier];
		page.cardView.alpha = DEFAULT_MAX_ALPHA;
	});
}
// }}}

// iOS 8 {{{
- (void)applicationProcessDidExit:(FBApplicationProcess *)applicationProcess withContext:(id)context {
	%orig;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		AuxoCollectionView *acv = [%c(AuxoCollectionView) activeCollectionView];
		AuxoCollectionViewCell *page = [acv pageForDisplayIdentifier:applicationProcess.bundleIdentifier];
		page.cardView.alpha = g_minAlpha;
	});
}

- (void)applicationProcessWillLaunch:(FBApplicationProcess *)applicationProcess {
	%orig;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		AuxoCollectionView *acv = [%c(AuxoCollectionView) activeCollectionView];
		AuxoCollectionViewCell *page = [acv pageForDisplayIdentifier:applicationProcess.bundleIdentifier];
		page.cardView.alpha = DEFAULT_MAX_ALPHA;
	});
}
// }}}

- (id)init {
	id rtn = %orig;
	
	if (rtn) {
		g_sbWorkspace = rtn;
	}
	
	return rtn;
}

%end


%hook SBControlCenterController

- (BOOL)isVisible {
	if (nowCoveredAppIsDeactivating) return NO;
	
	return %orig;
}

%end


%hook SBApplicationController

%new
- (SBApplication *)__auxole_mod_applicationWithIdentifier:(NSString *)identifier {
	static SEL selector = nil;
	static dispatch_once_t once;
	
	dispatch_once(&once, ^{
		if ([self respondsToSelector:@selector(applicationWithBundleIdentifier:)]) {
			selector = @selector(applicationWithBundleIdentifier:);
		}
		else if ([self respondsToSelector:@selector(applicationWithDisplayIdentifier:)]) {
			selector = @selector(applicationWithDisplayIdentifier:);
		}
	});
	
	if (selector == nil) return nil;
	
	return [self performSelector:selector withObject:identifier];
}

- (void)_sendInstalledAppsDidChangeNotification:(NSSet *)addedApps removed:(NSSet *)removedApps modified:(NSSet *)modifiedApps {
	%orig;
	
	if (springBoardLoaded == NO) return;
	
	if ([removedApps count] != 0) {
		SBUIController *uic = [%c(SBUIController) sharedInstanceIfExists];
		id appSwitcher = [uic switcherController];
		
		if ([appSwitcher respondsToSelector:@selector(_updateSnapshotsForce:)]) {
			[appSwitcher performSelector:@selector(_updateSnapshotsForce:) withObject:@(YES)];
			[appSwitcher performSelector:@selector(_rebuildAppListCache)];
		}
		else {
			[appSwitcher performSelector:@selector(_updateSnapshots)];
		}
	}
}

%end


%hook SBAppSwitcherModel

+ (BOOL)instancesRespondToSelector:(SEL)selector {
	if ([NSStringFromSelector(selector) isEqualToString:@"snapshot"]) {
		BOOL flag = %orig(@selector(snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary));
		
		if (flag)
			return NO;
	}
	
	return %orig;
}

%end


%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
	%orig;
	
	springBoardLoaded = YES;
	%init(AuxoLegacyEdition);
}

%end



%ctor {
	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
	
	if (![identifier isEqualToString:@"com.apple.springboard"] || (kCFCoreFoundationVersionNumber < 847.20))
		return;
	
	%init;
}



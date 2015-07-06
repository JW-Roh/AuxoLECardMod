

@interface AuxoAnimator : NSObject
- (void)invalidate;
- (void)animateFrom:(CGFloat)arg1 to:(CGFloat)arg2 fullDuration:(NSTimeInterval)arg3;
- (void)animateFrom:(CGFloat)arg1 to:(CGFloat)arg2 duration:(NSTimeInterval)arg3;
- (void)animateFrom:(CGFloat)arg1 to:(CGFloat)arg2 duration:(NSTimeInterval)arg3 startVelocity:(CGFloat)arg4;
@property(readonly, nonatomic) CGFloat currentAnimationDuration;
@property(readonly, nonatomic) CGFloat destinationValue;
@property(nonatomic) CGFloat value;
@end

@interface AuxoCardView : UIView {
	AuxoAnimator *animator;
}
+ (id)sharedIconViewMap;
+ (id)appSliderController;
@property(readonly, nonatomic) NSString *displayIdentifier;
//@property(readonly, nonatomic) SBAppSliderSnapshotView *snapshotView;
@property(readonly, nonatomic) UIView *snapshotContainer;
- (void)executeWhenLaunchedBlocks;
//- (void)performWhenLaunched:(CDUnknownBlockType)arg1;
- (void)updateAdaptiveColors;
- (void)layoutSubviews;
- (void)loadDisplayIdentifier:(id)arg1 withQueue:(id)arg2;
- (void)loadSnapshotViewIfMissingOnQueue:(id)arg1;
@end

@interface AuxoCollectionViewCell : UICollectionViewCell
@property(readonly, nonatomic) AuxoCardView *cardView;
- (void)restoreCardView;
@end

@interface AuxoCollectionView : UICollectionView {
	NSArray *items;
	AuxoCollectionViewCell *justSelectedCell;
	BOOL interactivelyAnimating;
	UIPanGestureRecognizer *panRecognizer;
	AuxoAnimator *animator;
	struct CGPoint animatingOffset;
}
+ (id)activeCollectionView;
- (void)collectionView:(id)arg1 willDisplayCell:(id)arg2 forItemAtIndexPath:(id)arg3;
- (id)collectionView:(id)arg1 cellForItemAtIndexPath:(id)arg2;
- (void)auxoCardViewWantsToClearAll:(id)arg1;
- (void)commitClearAll;
- (void)auxoCardViewWantsToClose:(id)arg1;
@property(nonatomic) CGFloat interactiveActivationProgress;
- (id)pageForDisplayIdentifier:(id)arg1;
@end



// iOS 7 {{{
@interface BKSApplicationProcessInfo : NSObject
@property(retain, nonatomic) NSNumber *pidNumber;
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
- (void)cancelEventsWithName:(NSString *)fp8;
- (void)executeOrAppendEvent:(id)fp8;
- (BOOL)isLocked;
@end
// }}}

@interface SBWorkspace : NSObject
- (void)setCurrentTransaction:(id)fp8;
@end
@interface SBWorkspace (firmware7)
- (id)bksWorkspace;
- (id)currentTransaction;
- (id)_applicationForBundleIdentifier:(id)fp8 frontmost:(BOOL)fp12;
- (id)_selectTransactionForAppActivationToApp:(SBApplication *)fp8 activationHandler:(void(^)(void))handler canDeactivateAlerts:(void)fp12;
- (id)_selectTransactionForAppActivationToApp:(SBApplication *)fp8 activationHandler:(void(^)(void))handler;
- (id)_selectTransactionForAppExited:(SBApplication *)fp8;
- (id)_selectTransactionForAppRelaunch:(SBApplication *)fp8;
- (id)_selectTransactionForAppActivationUnderMainScreenLock:(SBApplication *)fp8;
- (id)_selectTransactionForReturningToTheLockScreenFromApp:(SBApplication *)fp8 forceToBuddy:(BOOL)fp12 withActivationHandler:(void(^)(void))handler;
- (id)_selectTransactionForReturningToTheLockScreenWithActivationHandler:(void(^)(void))handler;
@end
@interface SBWorkspace (firmware8)
- (id)_selectTransactionForAppActivationToApp:(id)fp8 canDeactivateAlerts:(BOOL)fp12 withResult:(id)block;
- (id)_selectTransactionForAppActivationToApp:(id)fp8 withResult:(id)block;
- (id)_selectTransactionForAppActivationUnderMainScreenLock:(id)fp8 forRelaunch:(BOOL)fp12 withResult:(id)block;
- (id)_selectTransactionForReturningToTheLockScreenFromApp:(id)fp8 forceToBuddy:(BOOL)fp12 withResult:(id)block;
- (id)_selectTransactionForReturningToTheLockScreenWithResult:(id)block;
@end

// iOS 7 {{{
@interface SBWindowContextHostWrapperView : UIView @end
@interface SBWindowContextHostManager : NSObject
- (id)identifier;
- (id)screen;
- (void)disableHostingForRequester:(id)fp8;
- (SBWindowContextHostWrapperView *)hostViewForRequester:(id)fp8 enableAndOrderFront:(BOOL)fp12;
- (SBWindowContextHostWrapperView *)hostViewForRequester:(id)fp8;
- (void)hideHostViewOnDefaultWindowForRequester:(id)fp8 priority:(NSInteger)fp12;
- (void)hideHostViewOnDefaultWindowForRequester:(id)fp8;
- (void)unhideHostViewOnDefaultWindowForRequester:(id)fp8;
@end
// }}}



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
@property(readonly, copy, nonatomic) NSArray *pendingEvents;
- (BOOL)hasEventWithName:(id)arg1;
- (BOOL)hasEventWithPrefix:(id)arg1;
- (void)cancelEventsWithName:(id)arg1;
- (void)flushAllEvents;
- (void)flushPendingEvents;
- (void)flushEvents:(id)arg1;
- (void)executeOrInsertEvents:(id)arg1 atPosition:(int)arg2;
- (void)executeOrInsertEvent:(id)arg1 atPosition:(int)arg2;
@end
@interface FBWorkspaceEventQueue : BSEventQueue
+ (id)sharedInstance;
- (void)executeOrPrependEvents:(id)arg1;
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
- (id)contextManagerForSceneID:(id)arg1;
- (id)hostManagerForSceneID:(id)arg1;
@end
@interface FBWindowContextHostManager : NSObject
@property(readonly, nonatomic) FBScene *scene;
@property(copy, nonatomic) NSString *identifier;
- (void)disableHostingForRequester:(id)arg1;
- (id)hostViewForRequester:(id)arg1 enableAndOrderFront:(BOOL)arg2 appearanceStyle:(NSUInteger)arg3;
- (id)hostViewForRequester:(id)arg1 enableAndOrderFront:(BOOL)arg2;
- (id)hostViewForRequester:(id)arg1 appearanceStyle:(NSUInteger)arg2;
- (id)hostViewForRequester:(id)arg1;
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


static SBWorkspace *g_sbWorkspace = nil;
static BOOL nowCoveredAppIsDeactivating = NO;



void killSBApplicationForReasonAndReportWithDescription(NSString *bundleIdentifier, int reason, BOOL report, NSString *desc)
{
	if (desc == nil)
		desc = BKSApplicationTerminationReasonDescription(reason);
	
	NSString *label = [NSString stringWithFormat:@"TerminateApp: %@ (%@)", bundleIdentifier, desc];
	
	if (%c(SBWorkspaceEvent)) {
		SBWorkspaceEvent *event = [%c(SBWorkspaceEvent) eventWithLabel:label handler:^{
			BKSTerminateApplicationForReasonAndReportWithDescription(bundleIdentifier, reason, report, desc);
		}];
		
		SBWorkspaceEventQueue *eventQueue = [%c(SBWorkspaceEventQueue) sharedInstance];
		[eventQueue executeOrAppendEvent:event];
	}
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
	self.alpha = [[ac __auxole_mod_applicationWithIdentifier:displayIdentifier] isRunning] ? DEFAULT_MAX_ALPHA : DEFAULT_MIN_ALPHA;
}

- (void)layoutSubviews {
	%orig;
	
	SBApplicationController *ac = [%c(SBApplicationController) sharedInstanceIfExists];
	self.alpha = [[ac __auxole_mod_applicationWithIdentifier:self.displayIdentifier] isRunning] ? DEFAULT_MAX_ALPHA : DEFAULT_MIN_ALPHA;
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
			justSelectedCell.cardView.alpha = DEFAULT_MIN_ALPHA + self.interactiveActivationProgress;
		else
			justSelectedCell.cardView.alpha = DEFAULT_MAX_ALPHA;
	}
}

- (void)auxoCardViewWantsToClose:(AuxoCardView *)cardView {
	SBApplicationController *ac = [%c(SBApplicationController) sharedInstanceIfExists];
	SBApplication *application = [ac __auxole_mod_applicationWithIdentifier:cardView.displayIdentifier];
	SBApplication *frontmostApp = [(SpringBoard *)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
	
	if (application == frontmostApp) {
		quitTopApp();
	}
	
	killSBApplicationForReasonAndReportWithDescription(cardView.displayIdentifier, 1, NO, @"killed from AuxoLegacyEdition");
}

%end

%hook AuxoAnimator

- (BOOL)completeWithVelocity:(CGFloat)velocity cancelValue:(CGFloat)cancelThreshold successValue:(CGFloat)successThreshold {
	BOOL down = (successThreshold > DEFAULT_UP_THRESHOLD);
	BOOL rtn = %orig;
	
	if (down && rtn) {
		[self animateFrom:DEFAULT_DOWN_THRESHOLD to:0.0f duration:0.3f];
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
		page.cardView.alpha = DEFAULT_MIN_ALPHA;
	});
}

- (void)workspace:(id)workspace applicationDidStartLaunching:(BKSApplicationProcessInfo *)processInfo {
	%orig;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		AuxoCollectionView *acv = [%c(AuxoCollectionView) activeCollectionView];
		AuxoCollectionViewCell *page = [acv pageForDisplayIdentifier:processInfo.bundleIdentifier];
		page.cardView.alpha = DEFAULT_MAX_ALPHA;
	});
	%log;
}
// }}}

// iOS 8 {{{
- (void)applicationProcessDidExit:(FBApplicationProcess *)applicationProcess withContext:(id)context {
	%orig;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		AuxoCollectionView *acv = [%c(AuxoCollectionView) activeCollectionView];
		AuxoCollectionViewCell *page = [acv pageForDisplayIdentifier:applicationProcess.bundleIdentifier];
		page.cardView.alpha = DEFAULT_MIN_ALPHA;
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
	SBApplication *app = nil;
	
	if ([self respondsToSelector:@selector(applicationWithDisplayIdentifier:)]) {
		app = [self applicationWithDisplayIdentifier:identifier];
	}
	else if ([self respondsToSelector:@selector(applicationWithBundleIdentifier:)]) {
		app = [self applicationWithBundleIdentifier:identifier];
	}
	
	return app;
}

%end


%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
	%orig;
	
	%init(AuxoLegacyEdition);
}

%end



%ctor {
	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
	
	if (![identifier isEqualToString:@"com.apple.springboard"] || (kCFCoreFoundationVersionNumber < 847.20))
		return;
	
	%init;
}



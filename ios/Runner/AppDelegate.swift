import UIKit
import Flutter
import GoogleMaps
import workmanager


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyDUtU-M1rirqf_reKw2VjY5Y9EsoP6i3Z0")
    GeneratedPluginRegistrant.register(with: self)

    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
                // Registry in this case is the FlutterEngine that is created in Workmanager's
                // performFetchWithCompletionHandler or BGAppRefreshTask.
                // This will make other plugins available during a background operation.
                GeneratedPluginRegistrant.register(with: registry)
            }

    WorkmanagerPlugin.registerBGProcessingTask(withIdentifier: "bg_undp_gems.fieldvisit")
    WorkmanagerPlugin.registerBGProcessingTask(withIdentifier: "bg_undp_gems.addnewchng")
    WorkmanagerPlugin.registerBGProcessingTask(withIdentifier: "bg_undp_gems.fetchothoff")
    WorkmanagerPlugin.registerBGProcessingTask(withIdentifier: "bg_undp_gems.fetchallloc")
//
//
    WorkmanagerPlugin.registerPeriodicTask(withIdentifier: "bg_undp_gems.clrfvloc", frequency: NSNumber(value: 20 * 60))
    WorkmanagerPlugin.registerPeriodicTask(withIdentifier: "bg_ios_undp_gems.fallocbg", frequency: NSNumber(value: 20 * 60))
    WorkmanagerPlugin.registerPeriodicTask(withIdentifier: "bg_undp_gems.clraddnfvloc", frequency: NSNumber(value: 20 * 60))

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/purchase_api.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/common/message_dialog.dart';

class OffersSheet extends StatefulWidget {
  const OffersSheet({super.key});

  @override
  State<OffersSheet> createState() => _OffersSheetState();
}

class _OffersSheetState extends State<OffersSheet> {
  ListState _state = ListState.init;

  late final List<Package> _packages;
  late final AuthenticationProvider authProvider;

  Future _fetchOffers() async {
    setState(() {
      _state = ListState.loading;
    });

    final offerings = await PurchaseApi().fetchOffers();
    if (offerings.isNotEmpty) {
      _packages = offerings
          .map((offer) => offer.availablePackages)
          .expand((element) => element)
          .toList();
    }

    if (_state != ListState.disposed) {
      setState(() {
        _state = offerings.isEmpty ? ListState.empty : ListState.done;
      });
    }
  }

  @override
  void dispose() {
    _state = ListState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      authProvider = Provider.of<AuthenticationProvider>(context);
      _fetchOffers();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Premium Plans"),
      ),
      child: SafeArea(child: _portraitBody())
    );
  }

  Widget _portraitBody() {
    switch (_state) {
      case ListState.done:
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Lottie.asset(
                          "assets/lottie/premium.json",
                          height: 128,
                          width: 128,
                          frameRate: FrameRate(60)
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.all_inclusive_rounded, color: CupertinoColors.white),
                          ),
                          Text("Unlimited User List", style: TextStyle(color: CupertinoColors.white, fontSize: 16))
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.all_inclusive_rounded, color: CupertinoColors.white),
                          ),
                          Text("Unlimited Watch Later", style: TextStyle(color: CupertinoColors.white, fontSize: 16))
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.stars_rounded, color: CupertinoColors.white),
                          ),
                          Text("Full Access to AI Assistant", style: TextStyle(color: CupertinoColors.white, fontSize: 16))
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.stars_rounded, color: CupertinoColors.white),
                          ),
                          Text("AI Suggestions once every week", style: TextStyle(color: CupertinoColors.white, fontSize: 16))
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(CupertinoIcons.folder_fill_badge_plus, color: CupertinoColors.white),
                          ),
                          Text("20 Custom Lists with 25 Entries each", style: TextStyle(color: CupertinoColors.white, fontSize: 16))
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.workspace_premium_rounded, color: CupertinoColors.white),
                          ),
                          Text("Premium Badge", style: TextStyle(color: CupertinoColors.white, fontSize: 16))
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.line_axis_rounded, color: CupertinoColors.white),
                          ),
                          Text("Detailed and More Statistics", style: TextStyle(color: CupertinoColors.white, fontSize: 16))
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.more_horiz_rounded, color: CupertinoColors.white),
                          ),
                          Text("More soon...", style: TextStyle(color: CupertinoColors.white, fontSize: 16))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 250
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    final package = _packages[index];
                    final product = package.storeProduct;

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        setState(() {
                          _state = ListState.loading;
                        });

                        try {
                          await Purchases.purchasePackage(package);

                          if (context.mounted) {
                            if (_state != ListState.disposed) {
                              setState(() {
                                _state = ListState.done;
                              });
                            }

                            showCupertinoDialog(
                              context: context,
                              builder: (_) => const MessageDialog("✨ Successfuly purchased. Thank you for becoming a premium member. Please wait little bit longer while we update your account.")
                            );

                            showCupertinoDialog(context: context, builder: (_) => const LoadingDialog());

                            PurchaseApi().checkUserPremiumStatus().then((_) {
                              authProvider.setBasicUserInfo(PurchaseApi().userInfo);
                              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                            });
                          }
                        } on PlatformException catch (e) {
                          if (_state != ListState.disposed) {
                            setState(() {
                              _state = ListState.done;
                            });
                          }

                          var errorCode = PurchasesErrorHelper.getErrorCode(e);
                          if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
                            if (context.mounted) {
                              showCupertinoDialog(
                                context: context,
                                builder: (_) => ErrorDialog(e.message ?? "Failed to purchase.")
                              );
                            }
                          }
                        }
                      },
                      child: ClipRRect(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors().onDarkBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(width: 2, color: (product.identifier == "watchlistfy_premium_1mo" || product.identifier == "watchlistfy_premium_1mo:monthly-autorenewing") ? CupertinoColors.activeGreen : CupertinoColors.systemBlue)
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          padding: const EdgeInsets.all(6),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          product.title,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: CupertinoColors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if(!(product.identifier == "watchlistfy_premium_supporter_1mo" || product.identifier == "watchlistfy_premium_supporter_1mo:monthly-autorenewing"))
                                  Container(
                                    decoration: BoxDecoration(
                                      color: (product.identifier == "watchlistfy_premium_supporter_annual" || product.identifier == "watchlistfy_premium_supporter_annual:annual-autorenewing")
                                      ? AppColors().primaryColor
                                      : CupertinoColors.activeGreen,
                                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                      !(product.identifier == "watchlistfy_premium_supporter_annual" || product.identifier == "watchlistfy_premium_supporter_annual:annual-autorenewing")
                                      ? "Better Price"
                                      : "Best Offer",
                                      style: const TextStyle(
                                        color: CupertinoColors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    product.priceString + _identifierToString(product.identifier),
                                    style: const TextStyle(
                                      color: CupertinoColors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 8, bottom: 4),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Cancel anytime",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: CupertinoColors.systemGrey
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: _packages.length,
                ),
              ),
            ],
          ),
        );
      case ListState.empty:
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text("Couldn't find anything."),
          ),
        );
      default:
        return const Center(child: LoadingView("Loading"));
    }
  }

  String _identifierToString(String identifier) {
    if(identifier.contains("1mo")) {
      return "/month";
    } else if(identifier.contains("annual")) {
      return "/year";
    } else {
      return "";
    }
  }
}
// SignalR messages
import 'package:logging/logging.dart';

const initMessage = 'Init';
const pingMessage = 'ping';
const pongMessage = 'pong';
const assetsMessage = 'asset-list';
const balancesMessage = 'spot-wallet-balances';
const instrumentsMessage = 'spot-insrument-list';
const bidAskMessage = 'spot-bidask';
const marketReferenceMessage = 'market-reference';
const periodPricesMessage = 'base-prices';
const basePricesMessage = 'prices-base-currency';
const clientDetailMessage = 'client-detail';
const keyValueMessage = 'key-values';
const campaignsBannersMessage = 'campaigns-banners';
const referralStatsMessage = 'referrer-stats';
const kycCountriesMessage = 'kyc-countries';
const indicesMessage = 'index-details';
const convertPriceSettingsMessage = 'convert-price-settings';
const marketInfoMessage = 'market-info';
const paymentMethodsMessage = 'payment-methods';
const blockchainsMessage = 'blockchains';
const referralInfoMessage = 'referral-info';
const recurringBuyMessage = 'recurring-buys';
const earnOffersMessage = 'earn-offers';
const earnProfileMessage = 'earn-profile';

// KeyValue
const watchlistKey = 'watchlist';

// Logging levels
const transport = Level('🚚Transport', 1);
const contract = Level('📜Contract', 2);
const signalR = Level('🔔SignalR', 6);

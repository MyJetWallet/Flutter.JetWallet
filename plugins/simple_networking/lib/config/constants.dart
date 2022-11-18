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
const assetWithdrawalFeeMessage = 'asset-withdrawal-fees';
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
const earnOffersMessage = 'high-yield-profile';
const initFinished = 'init-finished';
const cardsMessage = 'cards';
const cardLimitsMessage = 'cards-limits';
const nftCollectionsMessage = 'nft-collections';
const nftMarketMessage = 'nft-market';
const nftPortfolioMessage = 'nft-portfolio';
const fireblocksMessages = 'fireblocks-messages';

// KeyValue
const watchlistKey = 'watchlist';
const cardsKey = 'cards';
const lastUsedPaymentMethod = 'lastUsedPaymentMethod';

// Logging levels
const transport = Level('🚚Transport', 1);
const contract = Level('📜Contract', 2);
const signalR = Level('🔔SignalR', 6);

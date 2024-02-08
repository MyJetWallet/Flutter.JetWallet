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
const paymentMethodsNewMessage = 'payment-methods-v2';
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
const operationHistoryMessages = 'operation-history';
const globalSendMethods = 'global-send-methods';
const incomingGiftsMessage = 'incoming-gifts';
const rewardsProfileMessage = 'rewards-profile';
const bankingProfileMessage = 'banking-profile';
const pendingOperationCountMessage =  'operation-count';
const investAllActivePositionsMessage = 'invest-positions';
const investInstrumentsMessage = 'invest-instruments';
const investPricesMessage = 'invest-current-prices';
const investSectorsMessage = 'invest-sectors';
const investWalletMessage = 'invest-wallet-profile';
const earnWalletProfile = 'earn-wallet-profile';

// KeyValue
const watchlistKey = 'watchlist';
const favoritesInstrumentsKey = 'favoritesInstruments';
const viewedRewardsKey = 'viewedRewards';
const cardsKey = 'cards';
const cardsSimpleKey = 'cardsSimple';
const lastUsedPaymentMethod = 'lastUsedPaymentMethod';

// Logging levels
const transport = Level('🚚Transport', 1);
const contract = Level('📜Contract', 2);
const signalR = Level('🔔SignalR', 6);

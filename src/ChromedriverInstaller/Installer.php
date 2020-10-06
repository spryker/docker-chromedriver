<?php

namespace ChromedriverInstaller;

use Composer\Composer;
use Composer\Config;
use Composer\IO\BaseIO as IO;
use Composer\Script\Event;

class Installer
{
    const PACKAGE_NAME = 'spryker/docker-chromedriver';

    /** @var Composer */
    protected $composer;

    /** @var IO */
    protected $io;

    /**
     * Installer constructor.
     * @param Composer $composer
     * @param IO $io
     */
    public function __construct(Composer $composer, IO $io)
    {
        $this->composer = $composer;
        $this->io = $io;
    }

    /**
     * @param Event $event
     */
    public static function installChromedriver(Event $event): void
    {
        $installer = new static(
            $event->getComposer(),
            $event->getIO()
        );

        $installer->run();
    }

    /**
     * @return void
     */
    protected function run(): void
    {
        /** @var Config $config */
        $config = $this->composer->getConfig();
        $dir_bin = $config->get('bin-dir');
        $dir_vendor = $config->get('vendor-dir') . '/' . static::PACKAGE_NAME;
        $revision = $config->get('chromium-revision') ?? 0;

        if (getenv('COMPOSER_IGNORE_CHROMEDRIVER') == '1') {
            echo "[Chromedriver] Skipped install due to COMPOSER_IGNORE_CHROMEDRIVER." . PHP_EOL;
            return;
        }

        echo "[Chromedriver] Suggested Revision = {$revision}" . PHP_EOL;

        passthru("rm -rf {$dir_vendor}/chrome*");
        passthru("{$dir_vendor}/chromium-installer {$revision} {$dir_vendor} false {$dir_bin}");
        passthru("rm -rf {$dir_vendor}/*.zip");
    }

}
